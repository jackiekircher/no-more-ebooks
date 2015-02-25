##
# a logger just for keepin track of new ebooks accounts
# that are added to the blocklist
#
# outputs to /log/accounts.log
class AccountLogger < Logger
  def initialize
    super(Rails.configuration.x.account_log, 10, 102400)
    @formatter = proc do |level, datetime, prgname, msg|
                   "\n[#{datetime}] #{level}\n  #{msg}\n"
                 end
  end
end
