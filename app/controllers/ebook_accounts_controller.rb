class EbookAccountsController < ApplicationController

  def blocklist
    @blocked_accounts = EbookAccount.all
  end
end
