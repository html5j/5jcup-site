require 'spec_helper'
require 'pry-debugger'

describe Users::OmniauthCallbacksController do
  describe 'facebook login with no login' do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    it "facebook uid check" do
      request.env["omniauth.auth"]['uid'].should == '1234'
      request.env["omniauth.auth"]['info']['email'].should == 'hal@hoge.com'
    end
    describe "redirect to create new user if no user found" do
      subject {get :facebook}
      it "should redirect to new_user" do
        expect(subject).to redirect_to(new_user_registration_url)
      end
      #it "should create new user with no pass" do
      #  get :facebook
      #  expect(User.where({email: 'hal@email.com'}).count).to be == 1
      #  expect(User.where({email: 'hal@email.com'}).first.name).to be == 'Hal Seki'
      #  expect(User.where({email: 'hal@email.com'}).first.password).to be_nil
      #end
      #it "should redirect to edit page" do
      #  expect(subject).to redirect_to(edit_user_registration_url)
      #end
    end

  end

  describe 'facebook login with exsisting email but first' do
    before do
      FactoryGirl.create(:user)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    it "facebook uid check" do
      expect(User.count).to be 1
      request.env["omniauth.auth"]['uid'].should == '1234'
      request.env["omniauth.auth"]['info']['email'].should == 'hal@hoge.com'
    end
    describe "redirect to login page if same email found" do
      subject {get :facebook}
      it "should redirect to new_user" do
        expect(subject).to redirect_to(new_user_session_path)
        #expect(session).to include('devise.user_attributes')
      end
    end

  end

#  describe 'Twitter login with no login' do
#    before do
#      request.env["devise.mapping"] = Devise.mappings[:user]
#      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
#        :provider => 'twitter',
#        :uid => '1234'
#      })
#    end
#    describe "redirect to create new user if no user found" do
#      subject {get :twitter}
#      it "should create new user" do
#        expect{subject}.to change{User.where({email: 'hal@email.com'}).count}.from(0).to(1)
#      end
#      it "should create new user with no pass" do
#        get :facebook
#        expect(User.where({email: 'hal@email.com'}).count).to be == 1
#        expect(User.where({email: 'hal@email.com'}).first.name).to be == 'Hal Seki'
#        expect(User.where({email: 'hal@email.com'}).first.password).to be_nil
#      end
#      it "should redirect to edit page" do
#        expect(subject).to redirect_to(edit_user_registration_url)
#      end
#    end
#
#  end

  #it 'show new user registration if there is no same account and not login' do
  #  expect(request.env['omniauth.auth']['info']['email']).to eq('hal@email.com')
  #  expect(get :create, :providor => 'facebook').to redirect_to('/users/registration/new_with_provider')
  #  #expect(get :create, :providor => 'facebook').to change{User.find({'email' => 'hal@email.com'}).count}.from(0).to(1)
  #end
end

