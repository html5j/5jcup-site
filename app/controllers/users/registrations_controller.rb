class Users::RegistrationsController < Devise::RegistrationsController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper
  before_filter :require_site
  def new
    build_resource({})
    @page ||= self.locomotive_page('/userregistration')

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => resource}))
      }
    end
  end
  # POST /resource
  def create
    @page ||= self.locomotive_page('/userregistration')
    build_resource(params.fetch(resource_name, {}))

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        @page = self.locomotive_page('/registrationconfirm')
        expire_data_after_sign_in!
        respond_to do |format|
          format.html {
             render :inline => @page.render(self.locomotive_context({}))
          }
        end
      end
    else
      clean_up_passwords resource
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'user' => resource, 'error' => devise_error_messages! }))
        }
      end
    end
  end

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div id="error_explanation">
      <h2>エラーが発生しました</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  def expire_data_after_sign_in!
    # session.keys will return an empty array if the session is not yet loaded.
    # This is a bug in both Rack and Rails.
    # A call to #empty? forces the session to be loaded.
    session.empty?
    session.keys.grep(/^devise\./).each { |k| session.delete(k) }
  end
end
