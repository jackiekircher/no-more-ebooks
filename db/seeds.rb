# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# seed in the list of _ebooks accounts on record
account_file = Rails.root + "db/account_list.txt"
File.open(account_file, 'r') do |file|
  file.each do |line|
    begin
      account = line.split(":")
      EbookAccount.create!(
        twitter_id:  account[0].strip.to_i,
        screen_name: account[1].strip
      )
    rescue ActiveRecord::RecordNotSaved
      puts "bullshit!"
      # I should do something real here
    end
  end
end
