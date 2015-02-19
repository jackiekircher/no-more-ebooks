class Client

  def initialize
    keys = NoMoreEbooks.api_keys

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

  def block(accounts)

    begin
      @client.block(accounts)
    rescue Twitter::Error::NotFound => error
      # is this output actually helpful??
      puts error
    end
  end

  def ebooks_search

    results = []
    (1..51).each do |i|
      begin
        accounts = @client.user_search("_ebooks",
                                       {page: i})
        accounts.select!{|r| r.screen_name =~ /_ebooks$/i}
        accounts.each do |account|
          results << {          id: account.id.to_s,
                       screen_name: account.screen_name }
        end

      rescue Twitter::Error::TooManyRequests => error
        puts  "rate limited exceeded :( :( :("
        print "  retry in #{error.rate_limit.reset_in} seconds"
        puts  " (#{Time.now + error.rate_limit.reset_in})"
        break
      end
    end

    return results
  end
end

