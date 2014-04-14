class UserAccount < Liquid::Drop
  include Mongoid::Document
  attr_accessible :provider, :uid
  ## Omniauthable
  field :provider,            :type => String
  field :uid,                 :type => String
  FACEBOOK = 'facebook'.freeze
  TWITTER = 'twitter'.freeze
  ## Omniauthable
  field :provider,            :type => String
  field :uid,                 :type => String

  belongs_to :user
end
