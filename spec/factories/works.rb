# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work do
    handle_name 'ハル関'
    twitter_id 'hal_sk'
    title "MyString"
    description "MyText"
    award_ids ["1"]
    tested_environment "MyText"
    url "http://yahoo.co.jp"
    technical_appeal_point "MyText"
    plan_appeal_point "MyText"
    remarks "MyText"
    published false
    user :user
    before(:create) do |work|
      award = Locomotive::ContentEntry.new
      award['_id'] = "1"
      award['category_id'] = "themeid"
      award['custom_fields_recipe'] = {'rules' => [
        { 'name' => 'category',
          'select_options' => [{
            '_id' => "themeid",
            'name' => {
              'ja' => 'テーマ'
            }
      }]}]}
      work.awards = [award]
    end
  end
end
