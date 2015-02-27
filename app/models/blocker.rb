class Blocker

  def initialize(client:, account_list:)
    @client   = client
    @accounts = account_list
  end

  def to_be_blocked
    accounts_to_block = @accounts.to_a.clone

    already_blocked = @client.blocked_ids
    accounts_to_block.reject! do |a|
      already_blocked.include?(a.twitter_id)
    end

    following = @client.friend_ids
    accounts_to_block.reject! do |a|
      following.include?(a.twitter_id)
    end

    return accounts_to_block
  end

  def block
    accounts_to_block = to_be_blocked
    return [] if accounts_to_block.size < 1

    blocked_accounts = @client.block(
                         accounts_to_block.map(&:twitter_id),
                       { include_entities: false,
                              skip_status: true }
                       )

    account_log = AccountLogger.new
    account_log.info do
      "successfully blocked #{blocked_accounts.size} accounts"
      # also log authenticated account info
    end

    return blocked_accounts.map do |account|
      EbookAccount.new(twitter_id: account.id,
                       screen_name: account.screen_name)
    end
  end
end
