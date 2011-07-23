require 'rubygems'
require 'httparty'
require 'hashie'
require 'cgi'
require 'pp'
require 'oauth'
require 'json'

include Hashie

API_KEY="AIzaSyDHHBe1hNgI5PXsZoCAFACASmTMpbE9EXQ"

class Geocoder
  include HTTParty
  def self.address_to_lat_long(address)
    r = get "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=#{CGI.escape(address)}"
    result = Mash.new r
    # puts result.inspect
    lat_long = result.results.first.geometry.location
    Mash.new :latitude => lat_long.lat, :longitude => lat_long.lng
  end
end

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
    
    path = "/v2/search?category_filter=vinyl_records&sort=1" # nearest first
    path += "&location=#{CGI.escape(options[:address])}" if options[:address]
    path += "&ll=#{options[:latitude]},#{options[:longitude]}" if options[:latitude] && options[:longitude]

    result = Mash.new JSON.parse(access_token.get(path).body)
    result.businesses
  end
  
end

results = RecordStoreFinder.find(:address => '02139')

pp results

# {"region"=>
#   {"center"=>{"latitude"=>42.36847445, "longitude"=>-71.1119548},
#    "span"=>
#     {"latitude_delta"=>0.0087283900000017,
#      "longitude_delta"=>0.0215265599999839}},
#  "total"=>8,
#  "businesses"=>
#   [{"mobile_url"=>"http://lite.yelp.com/biz/pLj68ms2MrhRPOu6yNdINw",
#     "name"=>"Cheapo Records",
#     "location"=>
#      {"address"=>["538 Massachusetts Ave"],
#       "city"=>"Cambridge",
#       "display_address"=>
#        ["538 Massachusetts Ave", "Central Square", "Cambridge, MA 02139"],
#       "country_code"=>"US",
#       "postal_code"=>"02139",
#       "coordinate"=>{"latitude"=>42.364507, "longitude"=>-71.10217},
#       "state_code"=>"MA",
#       "neighborhoods"=>["Central Square"],
#       "geo_accuracy"=>8},
#     "image_url"=>
#      "http://s3-media2.px.yelpcdn.com/bphoto/FNwligGmhkEkYJzA2d07ew/ms.jpg",
#     "url"=>"http://www.yelp.com/biz/cheapo-records-cambridge",
#     "rating_img_url_large"=>
#      "http://media4.px.yelpcdn.com/static/20101216169592178/i/ico/stars/stars_large_4.png",
#     "rating_img_url_small"=>
#      "http://media2.px.yelpcdn.com/static/20101216418129184/i/ico/stars/stars_small_4.png",
#     "id"=>"cheapo-records-cambridge",
#     "snippet_text"=>
#      "I had been to the old location of Cheapo Records quite a few times, but since I left myself out of the loop in regards to its new location (yeah, I thought...",
#     "display_phone"=>"+1-617-354-4455",
#     "phone"=>"6173544455",
#     "rating_img_url"=>
#      "http://media2.px.yelpcdn.com/static/201012164084228337/i/ico/stars/stars_4.png",
#     "categories"=>[["Vinyl Records", "vinyl_records"]],
#     "snippet_image_url"=>
#      "http://s3-media3.px.yelpcdn.com/photo/KGZomsHy_zAQPDYOy97Dcw/ms.jpg",
#     "review_count"=>20},
#    {"mobile_url"=>"http://lite.yelp.com/biz/ssIoTWmqgZr3O4DW16eRjQ",
#     "name"=>"Weirdo Records",
#     "location"=>
#      {"address"=>["844 Massachusetts Ave"],
#       "city"=>"Cambridge",
#       "display_address"=>
#        ["844 Massachusetts Ave", "Central Square", "Cambridge, MA 02139"],
#       "country_code"=>"US",
#       "postal_code"=>"02139",
#       "coordinate"=>{"latitude"=>42.367116, "longitude"=>-71.107035},
#       "state_code"=>"MA",
#       "neighborhoods"=>["Central Square"],
#       "geo_accuracy"=>8},
#     "image_url"=>
#      "http://s3-media2.px.yelpcdn.com/bphoto/VixWUwYtTBrXSiS-JAfGow/ms.jpg",
#     "url"=>"http://www.yelp.com/biz/weirdo-records-cambridge",
#     "rating_img_url_large"=>
#      "http://media2.px.yelpcdn.com/static/201012162752244354/i/ico/stars/stars_large_4_half.png",
#     "rating_img_url_small"=>
#      "http://media4.px.yelpcdn.com/static/201012161127761206/i/ico/stars/stars_small_4_half.png",
#     "id"=>"weirdo-records-cambridge",
#     "snippet_text"=>
#      "WEIRDO RECORDS RULES! \n\nBy far the best and most eclectic selection for music and odds + ends. The owner Angela knows her stuff. Eveytime a place like...",
#     "display_phone"=>"+1-857-413-0154",
#     "phone"=>"8574130154",
#     "rating_img_url"=>
#      "http://media4.px.yelpcdn.com/static/201012163106483837/i/ico/stars/stars_4_half.png",
#     "categories"=>
#      [["Vinyl Records", "vinyl_records"], ["Music & DVDs", "musicvideo"]],
#     "snippet_image_url"=>
#      "http://s3-media3.px.yelpcdn.com/photo/Imkgc40wELHzYycw-uYILQ/ms.jpg",
#     "review_count"=>25},
#    {"mobile_url"=>"http://lite.yelp.com/biz/1qTsCQxZY7mAaj23PXEu4g",
#     "name"=>"Armageddon Shop Boston",
#     "location"=>
#      {"address"=>["12 Eliot St."],
#       "city"=>"Cambridge",
#       "display_address"=>
#        ["12 Eliot St.", "Harvard Square", "Cambridge, MA 02138"],
#       "country_code"=>"US",
#       "postal_code"=>"02138",
#       "coordinate"=>{"latitude"=>42.3724419, "longitude"=>-71.1217396},
#       "state_code"=>"MA",
#       "neighborhoods"=>["Harvard Square"],
#       "geo_accuracy"=>8},
#     "image_url"=>
#      "http://s3-media4.px.yelpcdn.com/bphoto/OflkYo-f6b1eJqYjpdm_-w/ms.jpg",
#     "url"=>"http://www.yelp.com/biz/armageddon-shop-boston-cambridge",
#     "rating_img_url_large"=>
#      "http://media2.px.yelpcdn.com/static/201012162752244354/i/ico/stars/stars_large_4_half.png",
#     "rating_img_url_small"=>
#      "http://media4.px.yelpcdn.com/static/201012161127761206/i/ico/stars/stars_small_4_half.png",
#     "id"=>"armageddon-shop-boston-cambridge",
#     "snippet_text"=>
#      "Latest purchase:\n1) DYS - Wolfpack\n2) Generation X - Valley Of The Dolls\n3) Minor Threat - First Two 7\"s on a 12\"\n4) Balthasar Gerards Kommando - A Dutch...",
#     "display_phone"=>"+1-617-492-1235",
#     "phone"=>"6174921235",
#     "rating_img_url"=>
#      "http://media4.px.yelpcdn.com/static/201012163106483837/i/ico/stars/stars_4_half.png",
#     "categories"=>[["Vinyl Records", "vinyl_records"]],
#     "snippet_image_url"=>
#      "http://s3-media4.px.yelpcdn.com/photo/y6m0Vk3L41yR52xLe1k6LA/ms.jpg",
#     "review_count"=>7}]}