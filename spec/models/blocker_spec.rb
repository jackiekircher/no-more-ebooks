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
    @twitter_client = instance_double("TwitterClient")
    allow(@twitter_client).to receive(:blocked_ids).and_return([])
    allow(@twitter_client).to receive(:friend_ids).and_return([])

    @accounts = [
      Account.new(twitter_id: 11, screen_name: "suzy"),
      Account.new(twitter_id: 22, screen_name: "bort")
    ]
  end

  describe "#to_be_blocked" do

    it "lists all accounts" do
      blocker = Blocker.new(client: @twitter_client,
                            account_list: @accounts)

      expect(blocker.to_be_blocked.count).to eq(@accounts.length)
    end

    it "does not include accounts already blocked" do
      b_account = Account.new(twitter_id: rand(100) + 30,
                              screen_name: "annoyotron")
      allow(@twitter_client).
        to receive(:blocked_ids).
        and_return([b_account.twitter_id])

      @accounts << b_account
      @accounts.shuffle!
      blocker = Blocker.new(client: @twitter_client,
                            account_list: @accounts)

      expect(blocker.to_be_blocked).not_to include(b_account)
    end

    it "does not include accounts currently followed" do
      f_account = Account.new(twitter_id: rand(100) + 30,
                              screen_name: "true friend")
      allow(@twitter_client).
        to receive(:friend_ids).
        and_return([f_account.twitter_id])

      @accounts << f_account
      @accounts.shuffle!
      blocker = Blocker.new(client: @twitter_client,
                            account_list: @accounts)

      expect(blocker.to_be_blocked).not_to include(f_account)
    end
  end

  describe "#block" do

    # should I put this somewhere else so that tests
    # never accidentally write out to the log?
    before :each do
      allow(AccountLogger).to receive(:new) do
        instance_double("AccountLogger").as_null_object
      end
    end

    it "does not ping the twitter api if there are no
        accounts to block" do
      blocker = Blocker.new(client: @twitter_client,
                            account_list: @accounts)
      allow(blocker).
        to receive(:to_be_blocked).and_return([])
      twitter_spy = spy(@twitter_client)

      blocker.block

      expect(twitter_spy).to_not have_received(:block)
    end

    it "blocks the accounts" do
      blocker = Blocker.new(client: @twitter_client,
                            account_list: @accounts)
      allow(blocker).
        to receive(:to_be_blocked).and_return(@accounts)
      allow(@twitter_client).
        to receive(:block).with(any_args).and_return([])

      blocker.block

      expect(@twitter_client).
        to have_received(:block).with(@accounts.map(&:twitter_id), anything)
    end
  end
end
