# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_account do
    provider "MyString"
    uid "MyString"
    token "MyString"
    auth_response "MyString"
  end
end
