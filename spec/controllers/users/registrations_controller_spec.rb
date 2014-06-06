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
    describe "update user info with social login" do
      before do
        @params = {
          :name => 'Hal Seki2',
          :handle_name => 'myHandle',
          :twitter_id => 'twittername',
          :user_password => 'hoghogehgoege',
          :user_password_confirmation => 'hoghogehgoege'
        }
      end
      it 'update user info' do
        subject.current_user.should_not be_nil
        subject {put :update}
        # doesn't work. why?
        #expect{subject}.to change(subject.current_user.name).from('Hal Seki').to('Hal Seki2')
      end
    end
  end
end

