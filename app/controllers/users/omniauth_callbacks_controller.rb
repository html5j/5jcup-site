class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
 def all
    user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    if user.persisted?
      sign_in user
      flash[:notice] = t('devise.omniauth_callbacks.success', :kind => User::SOCIALS[params[:action].to_sym])
      if user.need_additional
        redirect_to edit_user_registration_url
      else
        redirect_to cabinet_path
      end
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  User::SOCIALS.each do |k, _|
    alias_method k, :all
  end
end
