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
    work = Work.new
    respond_to do |format|
      format.html {
         render :inline => @page.render(self.locomotive_context({ 'work' => work}))
      }
    end
  end
end
