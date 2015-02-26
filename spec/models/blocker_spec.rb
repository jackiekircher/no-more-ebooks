require 'spec_helper'
require_relative '../../app/models/blocker'

class Account
  attr_accessor :twitter_id, :screen_name
  def initialize(twitter_id:, screen_name:)
    @twitter_id  = twitter_id
    @screen_name = screen_name
  end
end

RSpec.describe Blocker do

  before :each do
    @twitter_mock = double("twitter::client")
    allow(@twitter_mock).to receive(:blocked_ids).and_return([])
    allow(@twitter_mock).to receive(:friend_ids).and_return([])

    @accounts = [
      Account.new(twitter_id: 11, screen_name: "suzy"),
      Account.new(twitter_id: 22, screen_name: "bort")
    ]
  end

  describe "#to_be_blocked" do

    it "lists all accounts" do
      blocker = Blocker.new(client: @twitter_mock,
                            account_list: @accounts)

      expect(blocker.to_be_blocked.count).to eq(@accounts.length)
    end

    it "does not include accounts already blocked" do
      b_account = Account.new(twitter_id: rand(100) + 30,
                              screen_name: "annoyotron")
      allow(@twitter_mock).
        to receive(:blocked_ids).
        and_return([b_account.twitter_id])

      @accounts << b_account
      @accounts.shuffle!
      blocker = Blocker.new(client: @twitter_mock,
                            account_list: @accounts)

      expect(blocker.to_be_blocked).not_to include(b_account)
    end

    it "does not include accounts currently followed" do
      f_account = Account.new(twitter_id: rand(100) + 30,
                              screen_name: "true friend")
      allow(@twitter_mock).
        to receive(:friend_ids).
        and_return([f_account.twitter_id])

      @accounts << f_account
      @accounts.shuffle!
      blocker = Blocker.new(client: @twitter_mock,
                            account_list: @accounts)

      expect(blocker.to_be_blocked).not_to include(f_account)
    end
  end
end
