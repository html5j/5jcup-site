# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin, class:User do
    name "MyString"
    email "admin@hoge.com"
    password "mypassword"
    encrypted_password "encrypted!"
  end
end
