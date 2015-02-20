class EbookAccount

  ACCOUNT_FILE = File.expand_path(File.dirname(__FILE__)) +
                 '/db/accounts.stuff'

  def self.all_accounts
    accounts = []
    File.open(ACCOUNT_FILE, 'r') do |file|
      file.each do |line|
        account = line.split(":")
        accounts << {          id: account[0].strip.to_i,
                      screen_name: account[1].strip       }
      end
    end

    return accounts
  end

  def self.all_names
    all_accounts.map{|account| account[:screen_name]}
  end

  def self.all_ids
    all_accounts.map{|account| account[:id]}
  end
end
