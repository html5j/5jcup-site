class Users::RegistrationsController < Devise::RegistrationsController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper
  helper DeviseHelper
  helper Devise::OmniAuth::UrlHelpers


  before_filter :require_site
  def new
    build_resource({})
    @page ||= self.locomotive_page('/userregistration')

    session.delete('devise.user_attributes') if params.include?('new') && session.include?('devise.user_attributes')
    if session['devise.user_attributes']
      resource.attributes = session['devise.user_attributes']
      with_provider = true
    end
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => resource, 'errors' => [],
                                                                          'social_links' => resource.social_links,
                                                                          'with_provider' => with_provider || false
         }))
      }
    end
  end
  def new_with_provider
    build_resource({})
    @page ||= self.locomotive_page('/userregistration')

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => resource }))
      }
    end
  end
  # POST /resource
  def create
    build_resource(params.fetch(resource_name, {}))

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        resource.add_provider(session[:omniauth]) if session.include?('omniauth')
        @page = self.locomotive_page('/registrationconfirm')
        expire_data_after_sign_in!
        respond_to do |format|
          format.html {
             render :inline => @page.render(self.locomotive_context({}))
          }
        end
      end
    else
      @page ||= self.locomotive_page('/userregistration')
      clean_up_passwords resource
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'user' => resource, 'error' => devise_error_messages!, 'username' => resource.name,
                                                                    'social_links' => resource.social_links,
                                                                    'with_provider' => session.include?('oauth')}))
        }
      end
    end
  end

  def edit
    @page ||= self.locomotive_page('/useredit')

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'user' => resource, 'error' => devise_error_messages!,
                                                                'login_fb' => user_omniauth_authorize_path(:facebook),
                                                                'social_links' => resource.social_links,
                                                                'username' => resource.name }))
      }
    end
  end
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, params.fetch(resource_name, {}))
    yield resource if block_given?
    if resource_updated
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: '/userupdated'
    else
      clean_up_passwords resource
      logger.debug resource.errors
      @page ||= self.locomotive_page('/useredit')

      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'user' => resource, 'error' => devise_error_messages! }))
        }
      end
    end
  end


  def update_resource(resource, params)
    if (resource.password_required?)
      resource.update_with_password(params)
    else
      resource.assign_attributes(params)
      if (params['password'].blank?)
        resource.errors.add(:password, "を入力して下さい")
        false
      elsif (params['password'] != params['password_confirmation'])
        resource.errors.add(:password, "と確認用パスワードが違います")
        false
      else
        params['need_additional'] = false
        resource.update_without_password(params)
      end
    end
  end

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
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

  def after_sign_up_path_for(resource)
    '/registrationfinished'
  end
end
