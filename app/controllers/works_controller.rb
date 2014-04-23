class WorksController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper

  before_filter :require_site
  before_filter :authenticate_user!, :except => ['show', 'all']


  helper Locomotive::BaseHelper

  def all
    @page ||= self.locomotive_page('/workallindex')
    works = Work.where({:published => true})
    hworks = {}
    works.each{|item|
      hworks[item._id.to_s] = item
    }

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'works' => hworks, 'username' => username, 'msg' => flash[:notify]}))
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
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => awards, 'username' => username}))
      }
    end
  end


  def create
    params['work']['published'] = (params['work']['published'] == 'true')
    if (params['edit'])
      @work = Work.find(params['work']['_id'])
      @work.attributes = params['work']
    else
      @work = Work.new(params['work']) if @work.nil?
      @work.user = current_user
    end
    if @work.save
      logger.debug '**success'
      logger.debug @work.inspect
      redirect_to :action => 'show', :id => @work.id
    else
      errors = error_messages(@work)
      @page ||= self.locomotive_page('/worksedit')
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'work' => @work, 'awards' => awards, 'error' => errors, 'username' => username}))
        }
      end
    end
  end

  def show
    @page ||= self.locomotive_page('/worksshow')
    work = Work.find(params['id'])
    editable = (work.user == current_user)
    work =  nil if (work.user != current_user && !work.published)
    awards = []
    award_content = current_site.content_types.where(slug: 'awards').first
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
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => awards, 'username' => username, 'edit'=>true}.merge(self.file_options(work))))
      }
    end
  end

  def destroy
    Work.find((params["id"])).destroy
    flash[:notify] = '削除完了しました'
    render :json => {result:"ok"}
  end

  def remove_empty_file_values(params)
    logger.debug params['file']
    params.delete('file') if params['file'] == ''
  end
  def file_options(work)
    {
      'file_url'=>work.file_url,
      'file_cache'=>work.file_cache,
      'image1_url'=>work.image1_url,
      'image2_url'=>work.image2_url,
      'image3_url'=>work.image3_url,
      'image1_cache'=>work.image1_cache,
      'image2_cache'=>work.image2_cache,
      'image3_cache'=>work.image3_cache}
  end
  def username
    current_user ? current_user.name : nil
  end
  private
  def awards
    return @award unless @award.nil?
    award_content = current_site.content_types.where(slug: 'awards').first
    awards = award_content.entries.sort{|a,b|
      if (a['order'].nil? && a['order'].nil?)
        if (a['prize'].nil? && a['prize'].nil?)
          a['title'] <=> a['title']
        elsif (a['prize'].nil?)
          0
        elsif (b['prize'].nil?)
          -1
        else
          a['prize'] <=> a['prize']
        end
      elsif (a['order'].nil?)
        0
      elsif (b['order'].nil?)
        -1
      else
        a['order'] <=> b['order']
      end
    }
    @awards = {}
    awards.each{|award|
      if @awards[award.category].nil?
        @awards[award.category] = [award]
      else
        @awards[award.category] << award
      end
    }
    @awards
  end
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
