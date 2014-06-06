require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe 'facebook login with no login' do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    it "facebook uid check" do
      request.env["omniauth.auth"]['uid'].should == '1234'
      request.env["omniauth.auth"]['info']['email'].should == 'hal@email.com'
    end
    describe "redirect to create new user if no user found" do
      subject {get :facebook}
      it "should create new user" do
        expect{subject}.to change{User.where({email: 'hal@email.com'}).count}.from(0).to(1)
      end
      it "should redirect to edit page" do
        expect(subject).to redirect_to(edit_user_registration_url)
      end
    end

  end
  #it 'show new user registration if there is no same account and not login' do
  #  expect(request.env['omniauth.auth']['info']['email']).to eq('hal@email.com')
  #  expect(get :create, :providor => 'facebook').to redirect_to('/users/registration/new_with_provider')
  #  #expect(get :create, :providor => 'facebook').to change{User.find({'email' => 'hal@email.com'}).count}.from(0).to(1)
  #end
end

