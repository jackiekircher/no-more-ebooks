require 'rails_helper'

RSpec.describe EbookAccountsController, type: :controller do

  describe "GET #blocklist" do
    it "returns http success" do
      get :blocklist
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #block_confirmation" do
    it "returns http success" do
      blocker = instance_double("Blocker").as_null_object
      allow(Blocker).to receive(:new) { blocker }

      get :block_confirmation
      expect(response).to have_http_status(:success)
    end

    it "excludes whitelisted accounts" do
      accounts = double("EbookAccount")
      allow(EbookAccount).to receive(:bots) { accounts }

      blocker = instance_double("Blocker").as_null_object
      expect(Blocker).to receive(:new).
        with(client: anything, account_list: accounts).
        and_return(blocker)

      get :block_confirmation
    end
  end

  describe "POST #block" do
    it "returns http success" do
      blocker = instance_double("Blocker").as_null_object
      allow(Blocker).to receive(:new) { blocker }

      post :block
      expect(response).to have_http_status(:success)
    end

    it "excludes whitelisted accounts" do
      accounts = double("EbookAccount")
      allow(EbookAccount).to receive(:bots) { accounts }

      blocker = instance_double("Blocker").as_null_object
      expect(Blocker).to receive(:new).
        with(client: anything, account_list: accounts).
        and_return(blocker)

      post :block
    end
  end
end
