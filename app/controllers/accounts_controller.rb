class AccountsController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::ActionController::LocaleHelpers
  include Locomotive::ActionController::SectionHelpers
  include Locomotive::ActionController::UrlHelpers
  include Locomotive::ActionController::Ssl
  include Locomotive::ActionController::Timezone

  layout '/locomotive/layouts/application'

  before_filter :require_ssl

  before_filter :require_account

  before_filter :require_site

  before_filter :set_back_office_locale

  before_filter :set_current_content_locale

  before_filter :validate_site_membership

  #load_and_authorize_resource

  around_filter :set_timezone

  before_filter :set_current_thread_variables

  helper_method :sections, :current_ability

  helper Locomotive::BaseHelper, Locomotive::ContentTypesHelper

  self.responder = Locomotive::ActionController::Responder # custom responder

  respond_to :html

  rescue_from CanCan::AccessDenied do |exception|
    ::Locomotive.log "[CanCan::AccessDenied] #{exception.inspect}"

    if request.xhr?
      render json: { error: exception.message }
    else
      flash[:alert] = exception.message

      redirect_to pages_path
    end
  end

  sections 'settings'

  def show
    @count = User.count
    @tmp_count = User.where(confirmed_at:nil).count
    @users = User.all
    @works = Work.all
    downloads = Dl.all
    @downloads = []
    dl_count = Hash.new(0)
    material_content = current_site.content_types.where(slug: 'materials').first
    downloads.each do |dl|
      dl.set_material_object(material_content)
      @downloads << dl
      dl_count[dl.material] += 1
    end
    @downloads_count = Hash.new
    material_content.entries.all.each do |m|
      @downloads_count[m.material_name] = dl_count[m._slug]
    end
  end

  protected

  def set_current_thread_variables
    Thread.current[:account]  = current_locomotive_account
    Thread.current[:site]     = current_site
  end

  def current_ability
    @current_ability ||= Locomotive::Ability.new(current_locomotive_account, current_site)
  end

  def require_account
    authenticate_locomotive_account!
  end


end
