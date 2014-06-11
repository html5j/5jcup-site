require 'spec_helper'

describe UserAccountsController do
  #before do
  #  request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  #end
  #it "sets session vairable to the OmniAuth auth hash" do
  #  request.env["omniauth.auth"]['uid'].should == '1234'
  #end
  #describe 'user login' do
  #  login_admin
  #  it "require user login" do
  #    expect(subject.current_user).not_to be_nil
  #  end
  #end
  #it 'show new user registration if there is no same account and not login' do
  #  expect(request.env['omniauth.auth']['info']['email']).to eq('hal@email.com')
  #  expect(get :create, :providor => 'facebook').to redirect_to('/users/registration/new_with_provider')
  #  #expect(get :create, :providor => 'facebook').to change{User.find({'email' => 'hal@email.com'}).count}.from(0).to(1)
  #end
end

