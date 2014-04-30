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
    if (type == 'dlurl1')
      binding.pry
      url = context['material'][type].gsub('{{userid}}', current_user.id)
    else
      url = context['material'][type].url
    end
    Dl.create({:userid => current_user.id, :email => current_user.email, :url => url, :material => slug})
    #render :text => url
    redirect_to url
  end
end
