class WorksController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  include ActionView::Helpers::TagHelper

  before_filter :require_site
  before_filter :authenticate_user!, :except => ['show']


  helper Locomotive::BaseHelper

  def index
    @page ||= self.locomotive_page('/worksindex')
    works = current_user.works
    hworks = {}
    works.each{|item|
      hworks[item._id.to_s] = item
    }

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'works' => hworks, 'username' => current_user.name}))
      }
    end
  end

  def new
    @page ||= self.locomotive_page('/worksedit')
    work = Work.new
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => awards, 'username' => current_user.name}))
      }
    end
  end


  def create
    @work = Work.new(params['work'])
    @work.user = current_user
    logger.debug params['work']
    if @work.save
      logger.debug '**success'
      logger.debug @work.inspect
      redirect_to :action => 'show', :id => @work.id
    else
      errors = error_messages(@work)
      @page ||= self.locomotive_page('/worksedit')
      respond_to do |format|
        format.html {
           render :inline => @page.render(self.locomotive_context({ 'work' => @work, 'awards' => awards, 'error' => errors, 'username' => current_user.name}))
        }
      end
    end
  end

  def show
    @page ||= self.locomotive_page('/worksshow')
    work = Work.find(params['id'])
    logger.debug work.file_url
    editable = (work.user == current_user)
    work =  nil if (work.user != current_user && !work.published)
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => awards, 'editable' => editable, 'username' => current_user.name, 'file_url'=>work.file_url}))
      }
    end
  end

  def edit
    @page ||= self.locomotive_page('/worksedit')
    work = Work.find(params['id'])
    work.attributes = params['work']
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => awards, 'username' => current_user.name}))
      }
    end
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
