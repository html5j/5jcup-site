require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe 'facebook login with no login' do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    it "facebook uid check" do
      request.env["omniauth.auth"]['uid'].should == '1234'
    end
    it "redirect to create new user if no user found" do
      expect(get :facebook).to redirect_to(edit_user_registration_url)
    end

  end
  #it 'show new user registration if there is no same account and not login' do
  #  expect(request.env['omniauth.auth']['info']['email']).to eq('hal@email.com')
  #  expect(get :create, :providor => 'facebook').to redirect_to('/users/registration/new_with_provider')
  #  #expect(get :create, :providor => 'facebook').to change{User.find({'email' => 'hal@email.com'}).count}.from(0).to(1)
  #end
end

