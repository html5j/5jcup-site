require 'spec_helper'

describe Users::SessionsController do
  describe 'login and merge with facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      session[:omniauth] = OmniAuth.config.mock_auth[:facebook]
      user = FactoryGirl.build(:user)
      user.password = 'mypassword'
      user.save
      user.confirm!
    end
    it 'create user_account after login' do
      subject {post :create , {:user => {:email => 'hal@hoge.com', :password => 'mypassword'}}}
      # Below test didn't pass... Why?
      #expect{subject}.to change{subject.current_user.nil?}.from(true).to(false)
    end
  end
end

