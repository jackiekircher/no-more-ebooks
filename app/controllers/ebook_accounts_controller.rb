class EbookAccountsController < ApplicationController

  def blocklist
    @blocked_accounts = EbookAccount.all
  end

  def block_confirmation
    # shows a list of accounts that will be blocked
    blocker = Blocker.new(client: twitter_client,
                          account_list: EbookAccount.all)
    @accounts_to_block = blocker.to_be_blocked
  end

  def block
    blocker = Blocker.new(client: twitter_client,
                          account_list: EbookAccount.all)
    @accounts_blocked = blocker.block
  end
end
