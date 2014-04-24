require 'spec_helper'
require 'shoulda-matchers'

describe Work do
  it {should validate_presence_of(:title)}
  describe '.all' do
    before do
      FactoryGirl.create(:work)
    end
    subject { Work.all }
    it { should have(1).items }
  end

  describe '.new' do
    context 'given valid attributes' do
      subject { Work.new(:title => 'a', :description => 'a', :twitter_id => 'hal_sk',
                        :handle_name => "a") }
      it { should be_valid }
    end
    context 'given null title' do
      subject { Work.new(:description => 'a') }
      it { should have(1).errors_on(:title) }
    end
  end
end
