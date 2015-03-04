require 'rails_helper'

RSpec.describe EbookAccount, type: :model do

  describe "#whitelisted?" do

    it "returns true when the account is globally
        whitelisted" do
      account = EbookAccount.new(whitelisted: true)
      expect(account.whitelisted?).to be true
    end

    it "returns false when the account is not globally
        whitelisted" do
      account = EbookAccount.new(whitelisted: false)
      expect(account.whitelisted?).to be false
    end

    it "defaults to false for new accounts" do
      account = EbookAccount.new
      expect(account.whitelisted?).to be false
    end
  end
end
