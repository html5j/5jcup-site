require 'spec_helper'
require 'shoulda-matchers'

describe Work do
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:handle_name)}
  describe '.all' do
    before do
      FactoryGirl.create(:work)
    end
    subject { Work.all }
    it { should have(1).items }
  end

  describe '.new' do
    before(:each) do
      @award = FactoryGirl.build(:content_type)
      @award.entries_custom_fields.build label: 'title', type: 'string'
      @award.entries_custom_fields.build label: 'description', type: 'text'
      @award.entries_custom_fields.build label: 'category', type: 'text'
      @award.valid?
      @award.send(:set_label_field)
    end

    context 'work should load awards data' do
      work = Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a", :award_ids => ["1"])
      @award['category'] = 'テーマ'
      work.awards = [@award]
      it {
        work.awards.count.should == 1
      }
    end
    context 'given valid attributes' do
      work = Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a", :award_ids => ["1"])
      subject { work }
      it {
        should be_valid
      }
    end
    context 'given null title' do
      subject { Work.new(:description => 'a') }
      it { should have(1).errors_on(:title) }
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
  end
  class AwardObject
    def initialize(id)
      @id = id
    end
  end
end

