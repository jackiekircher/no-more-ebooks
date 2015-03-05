# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# seed in the list of _ebooks accounts on record
lists = [[ Rails.root + "db/account_list.txt",     false ],
         [ Rails.root + "db/global_whitelist.txt", true  ]]

lists.each do |list, whitelisted|
  File.open(list, 'r') do |file|
    file.each do |line|
      line    = line.split(":")
      account = { twitter_id:  line[0].strip.to_i,
                  screen_name: line[1].strip,
                  whitelisted: whitelisted }
      begin
        EbookAccount.create!(account)
      rescue ActiveRecord::RecordInvalid
        account = EbookAccount.where(twitter_id: account[:twitter_id]).first
        account.update(whitelisted: account[:whitelisted])
      end
    end
  end
end
