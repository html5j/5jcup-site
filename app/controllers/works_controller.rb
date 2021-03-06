class WorksController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper
  include ::Fivejcup::Award

  before_filter :require_site
  before_filter :authenticate_user!, :except => ['show', 'all']


  helper Locomotive::BaseHelper

  def all
    @page ||= self.locomotive_page('/workallindex')
    award_content = current_site.content_types.where(slug: 'awards').first
    if params[:order] == "title"
      order = :title.asc
    elsif params[:order] == "handle_name"
      order = :handle_name.asc
    else
      order = :id.desc
    end
    works = Work.where({:published => true})
    unless params[:title].blank?
      works = works.where(title: /#{params[:title]}/)
    end
    if !params[:awards].blank? and params[:awards].kind_of?(Array)
      awards_list = params[:awards].uniq.keep_if{|item| !item.blank?}
      unless awards_list.blank?
        award_ids = award_content.entries.in("_slug.ja" => awards_list).map(&:_id).map(&:to_s)
        works = works.in(award_ids: award_ids)
      end
    end
    works = works.order_by(order)
    new_works = []
    works.each do |work|
      work.awards = award_content.entries.in(_id: work.award_ids)
      new_works << work
    end
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'works' => new_works, 'username' => username, 'awards' => awards, 'order' => params[:order], 'msg' => flash[:notify]}))
      }
    end
  end

  def index
    @page ||= self.locomotive_page('/worksindex')
    works = current_user.works
    hworks = {}
    works.each{|item|
      hworks[item._id.to_s] = item
    }

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'works' => hworks, 'username' => username}))
      }
    end
  end

  def new
    @page ||= self.locomotive_page('/worksedit')
    work = Work.new
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'members_json' => '[]','awards' => awards, 'username' => username, 'user' => current_user}))
      }
    end
  end


  def create
    params['work']['published'] = (params['work']['published'] == 'true')
    params['work']['members'].reject!{|e| e.empty? }
    if (params['edit'])
      @work = Work.find(params['work']['_id'])
      @work.attributes = params['work']
    else
      @work = Work.new(params['work']) if @work.nil?
      @work.user = current_user
    end
    award_content = current_site.content_types.where(slug: 'awards').first
    @work.awards = award_content.entries
    if @work.save
      redirect_to :action => 'show', :id => @work.id
    else
      errors = error_messages(@work)
      @page ||= self.locomotive_page('/worksedit')
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'work' => @work, 'members_json' => members_json(@work), 'awards' => awards, 'error' => errors, 'username' => username}))
        }
      end
    end
  end

  def show
    @page ||= self.locomotive_page('/worksshow')
    work = Work.find(params['id'])
    editable = (work.user == current_user)
    award_content = current_site.content_types.where(slug: 'awards').first
    if (work.user != current_user && !work.published)
      if session[:award_account].nil?
        work =  nil 
      else
        session_award = award_content.entries.where("_slug.ja" => session[:award_account]).first
        if !work.award_ids.include? session_award._id.to_s
          work = nil
        end
      end
    end
    if work.nil?
      redirect_to "/"
      return
    end
    awards = []
    if (work != nil && !work.award_ids.nil?)
      work.award_ids.each{|id|
        awards << award_content.entries.find(id)
      }
    end
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => awards, 'editable' => editable, 'username' => username, 'awards' => awards}.merge(self.file_options(work))))
      }
    end
  end

  def edit
    @page ||= self.locomotive_page('/worksedit')
    work = Work.find(params['id'])
    work.attributes = params['work']
    work.members ||= []
    work.members.map!{|e|
      ERB::Util.html_escape(e)
    }
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'members_json' => members_json(work), 'awards' => awards, 'username' => username, 'edit'=>true}.merge(self.file_options(work))))
      }
    end
  end

  def destroy
    Work.find((params["id"])).destroy
    flash[:notify] = '削除完了しました'
    render :json => {result:"ok"}
  end

  def members_json(work)
    work.members.nil? ? '[]' : work.members.to_json
  end

  def remove_empty_file_values(params)
    logger.debug params['file']
    params.delete('file') if params['file'] == ''
  end
  def file_options(work)
    {
      'file_url'=>work.file_url,
      'file_cache'=>work.file_cache,
      'image1_url'=>work.image1_url(:medium),
      'image2_url'=>work.image2_url(:medium),
      'image3_url'=>work.image3_url(:medium),
      'image1_cache'=>work.image1_cache,
      'image2_cache'=>work.image2_cache,
      'image3_cache'=>work.image3_cache}
  end
  def username
    current_user ? current_user.name : nil
  end
  private
  def error_messages(resource)
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

end
