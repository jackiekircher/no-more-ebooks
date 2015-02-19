require          'logger'
require_relative 'client'

BASEPATH = File.expand_path(File.dirname(__FILE__)) + '/'
logger   = Logger.new(BASEPATH + 'logs/new_accounts.log',
                      10, 1024000)
logger.formatter = proc do |level, datetime, progname, msg|
                     "\n[#{datetime}] #{level}\n  #{msg}\n"
                   end

# read in list of accounts to block
ebooks_accounts = EbookAccount.all_ids

client  = Client.new         # authenticate with user context for jackiekircher
twitter = Client.new.twitter # authenticate with user context for jackiekircher

# remove accounts that have already been blocked
  # what happens if you try to block an account you've already blocked? - behaves the same
blocked = twitter.blocked_ids
ebooks_accounts.reject!{|e| blocked.include?(e)}

# remove accounts that the user is already following
#   this returns a cursored list so anyone following > 5000 people will
#   need to page through all of them...
following = twitter.friend_ids
ebooks_accounts.reject!{|e| following.include?(e)}

# create list of accounts that are following you to warn user they will be blocked
#   this returns a cursored list so anyone with > 5000 followers will
#   need to page through all of them...
followed_by = twitter.follower_ids
followed_by_ebooks = ebooks_accounts.select{|e| followed_by.include?(e)}

if followed_by_ebooks.size > 1
  puts "\nwarning: certain accounts that are about to be blocked are following you"
  puts followed_by_ebooks
  puts "\n"
end

# TODO
# allow option to not block these accounts or create a whitelist

# block as many accounts left on the list as possible
if ebooks_accounts.size > 1
  client.block(ebooks_accounts)
  logger.info do
    "successfully blocked #{ebooks_accounts.size} accounts"
  end
end
