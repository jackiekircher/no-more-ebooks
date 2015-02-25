require 'rails_helper'

RSpec.describe EbookAccountsController, type: :controller do

  describe "GET #blocklist" do
    it "returns http success" do
      get :blocklist
      expect(response).to have_http_status(:success)
    end
  end

end
