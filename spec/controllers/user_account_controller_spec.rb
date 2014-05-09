require 'spec_helper'

describe UserAccountController do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end
  it "sets session vairable to the OmniAuth auth hash" do
    request.env["omniauth.auth"]['uid'].should == '1234'
  end
  it 'show new user registration if there is no email' do
    expect(request.env['omniauth.auth']['info']['email']).to eq('hal@email.com')
    get :create, :providor => 'facebook'

  end

end

