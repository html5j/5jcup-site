# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :award, class: ::Locomotive::ContentEntry do
    _id "1"
    _label_field_name "label"
    label "label"
  end
end
