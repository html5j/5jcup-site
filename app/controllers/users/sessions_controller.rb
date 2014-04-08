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
    @page ||= self.locomotive_page('/loginpage')

    logger.debug flash[:alert]
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:alert]}))
      }
    end
  end

  def devise_error_messages!
    return "" if self.resource.errors.empty?

    messages = self.resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div id="error_explanation">
      <h2>エラーが発生しました</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
