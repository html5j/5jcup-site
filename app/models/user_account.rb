class UserAccount < Liquid::Drop
  include Mongoid::Document
  ## Omniauthable
  field :provider,            :type => String
  field :uid,                 :type => String
  field :token,               :type => String
  field :auth_response,       :type => String
  field :secret       ,       :type => String
  FACEBOOK = 'facebook'.freeze
  TWITTER = 'twitter'.freeze

  belongs_to :user, :class_name => "User", inverse_of: :user_accounts
end
