class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    if user.persisted?
      if (user.user_accounts.where(providor: request.env['omniauth.auth']['providor']).count > 0)
        if (current_user.blank?)
          sign_in user
          flash[:notice] = t('devise.omniauth_callbacks.success', :kind => User::SOCIALS[params[:action].to_sym])
          redirect_to "/"
        else
          redirect_to edit_user_registration_path
        end
      else
        session[:omniauth] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_session_path
      end
    else
      session[:omniauth] = request.env['omniauth.auth'].except('extra')
      session['devise.user_attributes'] = user.attributes
      session[:user_password] = user.password
      redirect_to new_user_registration_url
    end
  end

  User::SOCIALS.each do |k, _|
    alias_method k, :all
  end
end
