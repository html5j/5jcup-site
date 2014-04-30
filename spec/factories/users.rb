# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class:User do
    name "Hal"
    email "admin@hoge.com"
    password "mypassword"
    encrypted_password "encrypted!"
  end
end
