class Dl
  include Mongoid::Document
  include Mongoid::Timestamps
  field :userid, type: String
  field :email, type: String
  field :material, type: String
  field :url, type: String
end
