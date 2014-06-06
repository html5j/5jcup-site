# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class:User do
    id 1
    name "Hal"
    email "admin@hoge.com"
    password "mypassword"
    encrypted_password "encrypted!"
  end
end
FactoryGirl.define do
  factory :fbuser, class:User do
    id 1
    name "Hal"
    email "admin@hoge.com"
    password ""
    encrypted_password ""
    to_create do |instance|
      instance.save validate: false
    end
    after(:build) do |user|
      user.user_accounts << FactoryGirl.build(:user_account)
    end
  end
end
FactoryGirl.define do
  factory :user_account, class:UserAccount do
    provider "facebook"
    uid "MyString"
    token "mytoken"
    auth_response "auth_response"
  end
end

