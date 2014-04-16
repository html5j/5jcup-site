class Users::ConfirmationsController < Devise::ConfirmationsController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper
  before_filter :require_site

  def new
    self.resource = resource_class.new
    @page ||= self.locomotive_page('/resendconfirmation')

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:alert]}))
      }
    end
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    @page ||= self.locomotive_page('/resendconfirmation')
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      logger.debug(flash[:error])
      logger.debug(flash[:alert])
      logger.debug(self.resource.errors.inspect)
      logger.debug(error_messages)
      respond_to do |format|
       format.html {
          render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => error_messages}))
       }
      end
    end
  end

  protected
  def error_messages
    messages = self.resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div id="error_explanation">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?
      '/registrationfinished'
    else
      new_session_path(resource_name)
    end
  end
end

