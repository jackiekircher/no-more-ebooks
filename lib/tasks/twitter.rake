namespace :twitter do

  desc "ping twitter's search for user names that end
        in _ebooks and then add any new ones to the list
        of accounts"
  task find_more_ebooks: :environment do

    twitter_client = TwitterClient.new

    new_accounts = twitter_client.ebooks_search
    current_list = EbookAccount.select('twitter_id', 'screen_name').map do |account|
      { twitter_id:  account.twitter_id,
        screen_name: account.screen_name }
    end

    new_accounts -= current_list
    if new_accounts.size > 0

      # write new accounts
      new_accounts.each do |account|
        EbookAccount.create(
          twitter_id:  account[:twitter_id],
          screen_name: account[:screen_name]
        )
      end

      # block any new accounts as they're found
      #twitter_client.block(new_accounts.map(&:twitter_id))

      # log new accounts
      AccountLogger.new.info do
        message = "new accounts:\n"
        new_accounts.each do |account|
          message += "   #{account[:twitter_id]} \t"
          message += ":  #{account[:screen_name]}\n"
        end

        message
      end

    else
      AccountLogger.new.info do
        "NO new accounts found"
      end

    end
  end
end
