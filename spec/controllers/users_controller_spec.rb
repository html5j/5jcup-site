require 'spec_helper'

describe Users::RegistrationsController do
  include Devise::TestHelpers
  describe "login from fb" do
    login_admin
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      @password = 'password'
    end

    it 'show new user registration if there is no same account and not login' do
      get :new, :controller => 'registrations'
      expect(response).to have_selector('input#providor', :content=>'facebook')
      #expect(get :create, :providor => 'facebook').to change{User.find({'email' => 'hal@email.com'}).count}.from(0).to(1)
    end
  end
end


