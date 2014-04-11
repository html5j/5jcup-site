class DlController < ApplicationController
  include Locomotive::Routing::SiteDispatcher
  include Locomotive::Render
  include Locomotive::ActionController::LocaleHelpers
  before_filter :require_site
  def show
    slug =  params['slug']
    type =  params['type']
    @page ||= self.locomotive_page('/materials/' + slug)
    #logger.debug(@page.render(self.locomotive_context({})))
    context = self.locomotive_context({})
    url = context['material'][type]
    render :text => url
    #redirect_to url
  end
end
