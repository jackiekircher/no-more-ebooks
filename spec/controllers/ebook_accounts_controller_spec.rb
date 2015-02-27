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
      get :block_confirmation
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #block" do
    it "returns http success" do
      post :block
      expect(response).to have_http_status(:success)
    end
  end
end
