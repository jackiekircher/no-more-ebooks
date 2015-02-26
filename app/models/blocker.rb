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
end
