class AccountsController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::ActionController::LocaleHelpers
  include Locomotive::ActionController::SectionHelpers
  include Locomotive::ActionController::UrlHelpers
  include Locomotive::ActionController::Ssl
  include Locomotive::ActionController::Timezone
  include Fivejcup::Award

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
    @users = User.all
  end

  def edit_user
    @user = User.where(_id: params["_id"]).first
  end

  def update_user
    @user = User.where(_id: params["_id"]).first
    if @user
      @user.skip_confirmation!
      @user.skip_reconfirmation!
      @user.update_attributes(params[:user])
      if @user.save!
        redirect_to :action => :show
      else
        render :action => :edit_user
      end
    end
  end

  def delete_user
    @user = User.where(_id: params["_id"]).first
    @user.destroy
    redirect_to :action => :show
  end
  
  def show_works
    @works = Work.all
    @award_count = {}
    award_content = current_site.content_types.where(slug: 'awards').first
    award_content.entries.each do |award|
      count = Work.in(award_ids: [award._id.to_s]).count
      @award_count[award] = count
    end
  end

  def show_work
    @work = Work.where(_id: params["_id"]).first
    _awards = []
    award_content = current_site.content_types.where(slug: 'awards').first
    if (@work != nil && !@work.award_ids.nil?)
      @work.award_ids.each{|id|
        _awards << award_content.entries.find(id)
      }
    end
    @awards = _awards
  end
  
  def edit_work
    @work = Work.where(_id: params["_id"]).first
    @awards = awards
  end

  def update_work
    params['work']['members'].reject!{|e| e.empty? }
    @work = Work.find(params['_id'])
    @work.attributes = params['work']
    award_content = current_site.content_types.where(slug: 'awards').first
    @work.awards = award_content.entries
    if @work.save
      redirect_to :action => :show_works
    else
      @awards = awards
      render :action => :edit_work
    end
  end

  def delete_work
    @work = Work.where(_id: params["_id"]).first
    @work.destroy
    redirect_to :action => :show_works
  end

  def download_works_csv
    page = params["page"].blank? ? 1 : params["page"]
    works = Work.order_by(:_id.asc).page(page).per(100)
    @works = Array.new
    award_content = current_site.content_types.where(slug: 'awards').first
    works.each do |work|
      work.award_content = award_content
      @works << work
    end
    respond_to do |format|
      format.csv { render :csv => @works }
    end
  end
  
  def show_downloads
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
