require 'config/twitter_api_keys'

keys_file = Rails.root + "config/twitter_api_keys.yml"
Rails.configuration.x.twitter_api_keys_file = keys_file
Rails.configuration.x.twitter_api_keys      = TwitterAPIKeys.new(keys_file)
