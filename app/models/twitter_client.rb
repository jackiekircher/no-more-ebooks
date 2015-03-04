class TwitterClient

  def initialize(keys: Rails.configuration.x.twitter_api_keys)
    @client = self.class.connect_to_twitter(keys)
  end

  def self.raw_connection(keys: Rails.configuration.x.twitter_api_keys)
    return connect_to_twitter(keys)
  end

  def ebooks_search
    results = []
    (1..51).each do |i|
      begin
        accounts = @client.user_search("_ebooks", {page: i})
        accounts.select!{|r| r.screen_name =~ /_ebooks$/i}
        accounts.each do |account|
          results << { twitter_id:  account.id,
                       screen_name: account.screen_name }
        end

      rescue Twitter::Error::TooManyRequests => error
        Logger.new(STDOUT).fatal do |error|
          message  = "rate limited exceeded :( :( :(\n"
          message += "  retry in #{error.rate_limit.reset_in} seconds"
          message += " (#{Time.now + error.rate_limit.reset_in})"
        end
        break

      rescue Twitter::Error::ServiceUnavailable => error
        puts "Twitter is down, let's give it a sec (or 15)..."
        sleep(15)
        retry
      end
    end

    return results
  end

  def blocked_ids
    @client.blocked_ids
  end

  def friend_ids
    @client.friend_ids
  end

  def block(*accounts)
    @client.block(accounts)
  end


  private

  def self.connect_to_twitter(keys)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = keys.consumer_key
      config.consumer_secret     = keys.consumer_secret
      config.access_token        = keys.access_token
      config.access_token_secret = keys.access_token_secret
    end
  end
end
