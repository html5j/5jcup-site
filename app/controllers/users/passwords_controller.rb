class Users::PasswordsController < Devise::PasswordsController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper
  before_filter :require_site

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
    @page ||= self.locomotive_page('/passwordreset')

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:alert]}))
      }
    end
  end

end
