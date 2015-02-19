require_relative 'config/no_more_ebooks'

include NoMoreEbooks

# read in current accounts
new_list     = client.ebooks_search
current_list = EbookAccount.all_accounts
new_accounts = new_list - current_list

if new_accounts.size > 0

  # write new accounts
  File.open(NoMoreEbooks::BLOCKED, 'a') do |f|
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
