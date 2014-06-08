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
         render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:alert]}))
      }
    end
  end
end
