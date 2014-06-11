class UserAccountsController < ApplicationController
  before_filter :authenticate_user!

  def deauth
    current_user.user_accounts.where(provider: params[:provider]).first.delete
    render :json => [return:'success']
  end

end
