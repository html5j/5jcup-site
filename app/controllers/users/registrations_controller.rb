class Users::RegistrationsController < Devise::RegistrationsController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  before_filter :require_site
  def new
    build_resource({})
    @page ||= self.locomotive_page('/userregistration')

    logger.debug("##########" + resource.inspect + "###########")
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => resource}))
      }
    end
  end
  def create
    super
  end
end
