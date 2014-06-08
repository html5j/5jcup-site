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
        session['devise.user_attributes'] = {
          'email' => 'Hal Seki'
        }
      end
      it 'update user info' do
        subject {put :new}
        # doesn't work. why?
        #expect{subject}.to change(subject.current_user.name).from('Hal Seki').to('Hal Seki2')
      end
    end
  end
end

