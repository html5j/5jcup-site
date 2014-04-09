class Work
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :award_ids, type: Array
  field :tested_environment, type: String
  field :url, type: String
  field :technical_appeal_point, type: String
  field :plan_appeal_point, type: String
  field :remarks, type: String
  field :published, type: Boolean
end
