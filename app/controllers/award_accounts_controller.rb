class AwardAccountsController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::ActionController::LocaleHelpers
  include Locomotive::ActionController::SectionHelpers
  include Locomotive::ActionController::UrlHelpers
  include Locomotive::ActionController::Ssl
  include Locomotive::ActionController::Timezone

  
  
  before_filter :require_account

  before_filter :require_site

  helper Locomotive::BaseHelper

  self.responder = Locomotive::ActionController::Responder

  def login
    if not params[:login_name].blank? and not params[:login_pass].blank?
      account = @award_content.entries.where("_slug.ja" => params[:login_name]).where(password: params[:login_pass]).first
      unless account.nil?
        session[:award_account] = account._slug
        redirect_to :action => :show
      end
    end
  end

  def logout
    session[:award_account] = nil
    redirect_to :action => :login
  end
  
  def show
    if @award_account.nil?
      redirect_to :action => :login
    end
    @works = Work.in(award_ids: [@award_account._id.to_s]).all

    
  end

  def show_download
    if @award_account.nil?
      redirect_to :action => :login
    end
    @downloads = []
    dl_count = Hash.new(0)
    material_content = current_site.content_types.where(slug: 'materials').first
    materials = material_content.entries.where(award_id: @award_account._id)
    downloads = Dl.in(material: materials.map(&:_slug))
    downloads.each do |dl|
      dl.set_material_object(material_content)
      @downloads << dl
      dl_count[dl.material] += 1
    end
    @downloads_count = Hash.new
    materials.all.each do |m|
      @downloads_count[m.material_name] = dl_count[m._slug]
    end
    
  end
  
  protected

  def require_account
    @award_content = current_site.content_types.where(slug: 'awards').first
    unless session[:award_account].nil?
      @award_account = @award_content.entries.where("_slug.ja" => session[:award_account]).first
    end
  end
  
end
