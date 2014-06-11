Fabricator(:user) do
  id 1
  name 'user'
  email 'hal@georepublic.co.jp'
  password 'password'
  user_accounts(count:1){|attr, i| Fabricate(:user_account) }
end
