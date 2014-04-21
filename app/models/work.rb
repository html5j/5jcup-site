class Work < Clot::BaseDrop
  include Mongoid::Document
  validates_presence_of :title
  field :title, type: String
  field :description, type: String
  field :award_ids, type: Array
  field :tested_environment, type: String
  field :url, type: String
  field :technical_appeal_point, type: String
  field :plan_appeal_point, type: String
  field :remarks, type: String
  field :published, type: Boolean
  belongs_to :user

end
