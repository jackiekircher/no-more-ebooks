require_relative 'config/no_more_ebooks'

include NoMoreEbooks

# read in list of accounts to block
ebooks_accounts = EbookAccount.all_ids

# authenticated with user context for jackiekircher
twitter = client.twitter

# remove accounts that have already been blocked
blocked = twitter.blocked_ids
ebooks_accounts.reject!{|e| blocked.include?(e)}

# remove accounts that the user is already following
#   this returns a cursored list so anyone following > 5000
#   people will need to page through all of them...
following = twitter.friend_ids
ebooks_accounts.reject!{|e| following.include?(e)}

# create list of accounts that are following you to warn
# user they will be blocked
#   this returns a cursored list so anyone with > 5000
#   followers will need to page through all of them...
followed_by = twitter.follower_ids
followed_by_ebooks = ebooks_accounts.select{|e| followed_by.include?(e)}

if followed_by_ebooks.size > 1
  full_info = EbookAccount.all_accounts
  followed_by_ebooks.map! do |id|
    full_info[full_info.find_index{|a| a[:id] == id.to_s}]
  end

  puts "\nWARNING - certain accounts that are about to be blocked are following you"
  followed_by_ebooks.each do |account|
    puts "  #{account[:id]} \t:  #{account[:screen_name]}"
  end
  puts "\ncontinue? (y/n)"
  cont = gets.strip

  exit if cont != "y" && cont != "Y"
end

# TODO
# allow option to not block these accounts or create
# a whitelist

# block as many accounts left on the list as possible
if ebooks_accounts.size > 1
  client.block(ebooks_accounts)
  logger.info do
    "successfully blocked #{ebooks_accounts.size} accounts"
  end
end
