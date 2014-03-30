module Auth
  module AuthField
    extend ActiveSupport::Concern
    included do
      field :require_login,         type: Boolean, localize: true
    end
  end
end
