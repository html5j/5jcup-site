class Users::ConfirmationsController < Devise::ConfirmationsController
  protected
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?
      '/registrationfinished'
    else
      new_session_path(resource_name)
    end
  end
end

