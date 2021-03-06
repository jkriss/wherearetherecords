require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'httparty'
require 'hashie'
require 'oauth'
require 'haml'
require 'json'
require 'padrino-helpers'

include Hashie

Sinatra.register Padrino::Helpers

class RecordStoreFinder
  include HTTParty
  def self.find(options={})
    consumer_key = 'WOItd1AjXhCiFmZrEz8RLA'
    consumer_secret = 'viZl8QUC5UO7S8oUEaeNWWIFjwo'
    token = 'S3ahe6TxmBBdD9v4ST2J0MlsQB5jDk_S'
    token_secret = 'wMURx5b4bQu_w9H03e03iGTxpYA'

    api_host = 'api.yelp.com'

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
    access_token = OAuth::AccessToken.new(consumer, token, token_secret)
    
    # path = "/v2/search?category_filter=vinyl_records&sort=1" # nearest first
    path = "/v2/search?term=vinyl+records&sort=1" # nearest first
    path += "&location=#{CGI.escape(options[:address])}" if options[:address]
    path += "&ll=#{options[:latlong]}" if options[:latlong]

    result = Mash.new JSON.parse(access_token.get(path).body)
    if result.error
      raise Exception.new result.error.text
    else
      result.businesses
    end
  end
  
end

helpers do
  
  def map_url(store)
    q = "#{store.location.address} #{store.location.postal_code}"
    "http://maps.google.com?q=#{CGI.escape(q)}"
  end
  
  def map_img_url(store)
    loc = "#{store.location.address} #{store.location.postal_code}"
    loc = CGI.escape(loc)
    "http://maps.google.com/maps/api/staticmap?center=#{loc}&markers=size:small|color:blue|#{loc}&zoom=14&size=200x200&sensor=false"
  end
  
end

error do
  @error_message = env['sinatra.error'].message
  haml :error
end

get '/' do
  cache_control :public, :max_age => 3600
  haml :index
  # @address = '02139'
  # @stores = RecordStoreFinder.find :address => @address
  # haml :stores
end

post '/search' do
  q = params[:location]
  q = CGI.escape(q) unless q =~ /(-?\d+.\d+),(-?\d+.\d+)/
  redirect "/#{q}"
end

get '/favicon.ico' do
  404
end

get '/nothing' do
  s = Mash.new :name => 'The place with a long name', :display_phone => '+1-617-555-1212', :location => { :address => '1 main st', :postal_code => '02139', :display_address => ['1 Main st', 'Central Square', 'Cambridge MA 02139']}, :rating_img_url_small => "http://media2.px.yelpcdn.com/static/20101216418129184/i/ico/stars/stars_small_4.png"
  @stores = [s,s,s,s,s]
  haml :stores
end

get '/:address' do
  @address = params[:address]
  if @address =~ /(-?\d+.\d+),(-?\d+.\d+)/
    puts "-- finding by lat long: #{@address}"
    @stores = RecordStoreFinder.find :latlong => @address
  else
    puts "-- finding by address: #{@address}"
    @stores = RecordStoreFinder.find :address => @address
  end
  haml :stores
end