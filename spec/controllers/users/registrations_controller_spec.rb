require 'spec_helper'

describe Users::RegistrationsController do
  describe 'facebook login test' do
    login_fbuser
    it 'should have current user' do
      subject.current_user.should_not be_nil
    end
    describe "facebook login test" do
      it "should not show password field" do
        expect(subject).to_not have_selector("input#user_current_password")
      end
    end
  end
  describe "Through oauth" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      session[:omniauth] = OmniAuth.config.mock_auth[:facebook]
    end
    it "create user_account from provider info after create new user" do
      pending
      #post :create, {user: FactoryGirl.attributes_for(:user)}
      #expect(User.where(email:(FactoryGirl.attributes_for(:user))['email']).count).to eq(1)
    end
  end
end

