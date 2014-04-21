class WorksController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers

  before_filter :require_site
  before_filter :authenticate_user!


  helper Locomotive::BaseHelper

  def index
    @page ||= self.locomotive_page('/worksindex')
    works = Work.where({user_id:current_user.id})

    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'works' => works}))
      }
    end
  end

  def new
    @page ||= self.locomotive_page('/worksedit')
    award_content = current_site.content_types.where(slug: 'awards').first
    @awards = award_content.entries.sort{|a,b|
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
    work = Work.new
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work, 'awards' => @awards}))
      }
    end
  end
end
