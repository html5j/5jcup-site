class UserAccountsController < ApplicationController
  def create
    redirect_to '/users/registration/new'
  end

end
