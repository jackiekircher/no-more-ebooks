require_relative 'client'

BASEPATH  =  File.expand_path(File.dirname(__FILE__)) + '/'
BLOCKED   = 'db/accounts.stuff'
NEWACCLOG = 'logs/new_accounts.log'

# read in current accounts
client       = Client.new
new_list     = client.ebooks_search
current_list = BlockList.new(BASEPATH + BLOCKED)

# what to do here? I don't like assuming the same format
# from multiple sources but it's silly to use the BlockList
# file read to get new accounts when searching.
new_accounts = new_list - current_list.full_list

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
  File.open(BASEPATH + NEWACCLOG,'a') do |f|
    f.puts "\n[#{Time.now}]"
    f.puts "  new accounts:"
    new_accounts.each do |account|
      f.puts "    #{account[:id]} \t:  #{account[:screen_name]}"
    end
  end
else
  File.open(BASEPATH + NEWACCLOG,'a') do |f|
    f.puts "\n[#{Time.now}]"
    f.puts "  NO new accounts found"
  end
end
