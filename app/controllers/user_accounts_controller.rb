class UserAccountsController < ApplicationController
  def create
    redirect_to '/users/registration/new_with_provider'
  end

end
