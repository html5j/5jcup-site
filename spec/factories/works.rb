# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work do
    title "MyString"
    description "MyText"
    award_ids ""
    tested_environment "MyText"
    url "MyString"
    technical_appeal_point "MyText"
    plan_appeal_point "MyText"
    remarks "MyText"
    published false
  end
end
