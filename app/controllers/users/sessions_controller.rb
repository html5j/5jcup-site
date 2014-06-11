class Users::SessionsController < Devise::SessionsController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper
  before_filter :require_site
  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(params.fetch(resource_name, {}))
    clean_up_passwords(resource)
    self.resource.fetch_details(session[:omniauth]) if (session[:omniauth])
    @page ||= self.locomotive_page('/loginpage')

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => self.resource,
                                                                'error' => flash[:alert],
                                                                'social_links' => self.social_links(resource)
      }))
      }
    end
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    create_user_accounts(resource) if session[:omniauth]
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  def create_user_accounts(resource)
    auth = session[:omniauth]
    resource.user_accounts.create({
                                 :provider => auth.provider,
                                 :uid => auth.uid,
                                 :token => auth.credentials.token || nil
    })
    resource.save
    session.delete(:omniauth)
  end
  def social_links(resource)
    '<div class="sociallinks">' + User::SOCIALS.map do |s|
        '<li><a href="' + user_omniauth_authorize_path(s[0]) + '">' + s[1] + '経由でログイン</a></li>'
    end.join() + '</div>'
  end
end
