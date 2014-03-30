module Auth
  module AuthPage
    extend ActiveSupport::Concern

    included do
      before_filter :authcheck
    end
    def authcheck
        logger.info "Auth page"
    end
  end
end
