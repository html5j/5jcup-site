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
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      @page ||= self.locomotive_page('/sentresetlink')
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'user' => self.resource}))
        }
      end
    else
      logger.debug(resource.errors)
      flash[:error] = ""
      resource.errors.full_messages.each do |msg|
        flash[:error] << '<li>' + msg + '</li>'
      end
      @page ||= self.locomotive_page('/passwordreset')
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:error]}))
        }
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    @page ||= self.locomotive_page('/passwordedit')
    respond_to do |format|
      format.html {
        render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:error]}))
      }
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      sign_in(resource_name, resource)
      @page ||= self.locomotive_page('/endpasswordreset')
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'user' => self.resource}))
        }
      end
    else
      flash[:error] = ""
      resource.errors.full_messages.each do |msg|
        flash[:error] << '<li>' + msg + '</li>'
      end
      @page ||= self.locomotive_page('/passwordedit')
      respond_to do |format|
        format.html {
          render :inline => @page.render(self.locomotive_context({ 'user' => self.resource, 'error' => flash[:error]}))
        }
      end
    end
  end


end
