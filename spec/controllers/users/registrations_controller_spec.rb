require 'spec_helper'

describe Users::RegistrationsController do
  login_fbuser
  describe 'facebook login test' do
    before do

    end
    describe "facebook login test" do
      it "should not show password field" do
        expect(subject).to_not have_selector("input#user_current_password")
      end
    end
  end
end

