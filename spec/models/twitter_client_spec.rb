require 'spec_helper'
require_relative '../../app/models/twitter_client'

RSpec.describe TwitterClient do

  before :each do
    @twitter_mock = double("twitter::client")
  end

  it "initializes" do
    # how do I stub out this initialization?
    # TwitterClient.new
  end
end
