require 'spec_helper'
require 'shoulda-matchers'

describe Work do
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:handle_name)}
  describe '.all' do
    before do
      work = FactoryGirl.create(:work)
    end
    subject { Work.all }
    it { should have(1).items }
  end

  describe '.new' do
    before(:each) do
      @award = Locomotive::ContentEntry.new
      @award['_id'] = "1"
      @award['category_id'] = "themeid"
      @award['custom_fields_recipe'] = {'rules' => [
        { 'name' => 'category',
          'select_options' => [{
            '_id' => "themeid",
            'name' => {
              'ja' => 'テーマ'
            }
          },{
            '_id' => "nongenreid",
            'name' => {
              'ja' => 'ノンジャンル'
            }
          }

      ]}]}
    end

    context 'given valid attributes' do
      work = Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a", :award_ids => ["1"], :url => 'http://www.yahoo.co.jp')
      subject { work }
      it {
        work.awards = [@award]
        should be_valid
      }
    end
    context 'given null title' do
      subject { Work.new(:description => 'a') }
      it {
        should have(1).errors_on(:title)
      }
    end
    context 'given too long title' do
      subject { Work.new(:title => '12345678901234567890123456789012345678901') }
      it { should have(1).errors_on(:title) }
    end
    context 'given too long description' do
      subject { Work.new(:description => "0" * 501) }
      it { should have(1).errors_on(:description) }
    end
    context 'doesn\'t select any awards having theme' do
      subject { Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a") }
      it { should have(1).errors_on(:award_ids) }
    end
    context 'too many select non-genre awards' do
      subject { Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a", :awards_ids => ["non1", "non2", "non3", "non4", "1"]) }
      it { should have(1).errors_on(:award_ids) }
    end
    context 'url or file should be sent' do
      subject { Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a", :awards_ids => ["non1", "non2", "non3", "non4", "1"]) }
      it { subject.errors_on(:url).should include('かアプリケーションはどちらか必ず登録してください。') }
    end
  end
  class AwardObject
    def initialize(id)
      @id = id
    end
  end
end

