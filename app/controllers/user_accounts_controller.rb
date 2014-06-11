class UserAccountsController < ApplicationController
  before_filter :authenticate_user!

  def deauth
    render :json => []
  end

end
