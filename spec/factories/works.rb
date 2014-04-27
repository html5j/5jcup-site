# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work do
    handle_name 'ハル関'
    twitter_id 'hal_sk'
    title "MyString"
    description "MyText"
    award_ids ["1"]
    tested_environment "MyText"
    url "MyString"
    technical_appeal_point "MyText"
    plan_appeal_point "MyText"
    remarks "MyText"
    published false
  end
end
