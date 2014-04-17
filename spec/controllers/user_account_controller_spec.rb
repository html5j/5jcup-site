require 'spec_helper'

describe UserAccountController do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end
  it "sets session vairable to the OmniAuth auth hash" do
    request.env["omniauth.auth"]['uid'].should == '1234'
  end
  it 'create new user if there is no email' do

  end

end

