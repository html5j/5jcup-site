module Auth
  module AuthPage
    extend ActiveSupport::Concern

    included do
      before_filter :authcheck
    end
    def authcheck
      @page ||= self.locomotive_page
      authenticate_user! if @page.require_login
    end
  end
end
