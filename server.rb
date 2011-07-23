require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'httparty'
require 'hashie'
require 'oauth'
require 'haml'
require 'json'

include Hashie

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
    path += "&ll=#{options[:latitude]},#{options[:longitude]}" if options[:latitude] && options[:longitude]

    result = Mash.new JSON.parse(access_token.get(path).body)
    result.businesses
  end
  
end

helpers do
  
  def map_url(store)
    q = "#{store.location.address} #{store.location.postal_code}"
    "http://maps.google.com?q=#{CGI.escape(q)}"
  end
  
end

get '/' do
  haml :index
end

post '/search' do
  redirect "/#{CGI.escape(params[:location])}"
end

get '/:address' do
  @address = params[:address]
  @stores = RecordStoreFinder.find :address => @address
  haml :stores
end