class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def twitter_client(api_keys: Rails.configuration.x.twitter_api_keys)
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = api_keys.consumer_key
      config.consumer_secret     = api_keys.consumer_secret
      config.access_token        = api_keys.access_token
      config.access_token_secret = api_keys.access_token_secret
    end
  end
end
