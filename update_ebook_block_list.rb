require          'logger'
require_relative 'client'

BASEPATH =  File.expand_path(File.dirname(__FILE__)) + '/'
BLOCKED  = 'db/accounts.stuff'
logger   =  Logger.new(BASEPATH + 'logs/new_accounts.log',
                        10, 1024000)
logger.formatter = proc do |level, datetime, progname, msg|
                     "\n[#{datetime}] #{level}\n  #{msg}\n"
                   end

# read in current accounts
client       = Client.new
new_list     = client.ebooks_search
current_list = EbookAccount.all_accounts

# what to do here? I don't like assuming the same format
# from multiple sources but it's silly to use the
# EbookAccount file read to get new accounts when searching.
new_accounts = new_list - current_list

if new_accounts.size > 0

  # write new accounts
  File.open(BASEPATH + BLOCKED, 'a') do |f|
    new_accounts.each do |account|
      f.puts "#{account[:id]} \t:  #{account[:screen_name]}"
    end
  end

  # block any new accounts as they're found
  client.block(new_accounts.map{|a| a[:id].to_i})

  # log new accounts
  logger.info do
    message = "new accounts:\n"
    new_accounts.each do |account|
      message += "    #{account[:id]} \t"
      message += ":  #{account[:screen_name]}"
    end

    message
  end
else

  logger.info do
    "NO new accounts found"
  end
end
