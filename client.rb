require          'twitter'
require_relative 'api_keys'

class Client

  def initialize
    keys   = APIKeys.new

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = keys.consumer_key
      config.consumer_secret     = keys.consumer_secret
      config.access_token        = keys.access_token
      config.access_token_secret = keys.access_token_secret
    end
  end

  def twitter
    @client
  end
end

