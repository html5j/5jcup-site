require 'spec_helper'

describe User do

  describe '.new' do
    context 'given valid attributes' do
      subject { User.new(:email => 'hal@plants-web.jp', :password => 'password', :name => 'ハル') }
      it { should be_valid }
      its(:name) { eq 'ハル' }
    end
  end
  describe 'delete' do
    before do
      @work = FactoryGirl.create(:work)
    end

    context 'select all' do
      subject {Work.all}
      it { should have(1).items }
    end

    context 'work has user' do
      subject { @work.user }
      its(:name) { eq 'Hal' }
    end
    context 'delete user will delete works' do
      subject {
        @work.user.destroy
        subject { User.all }
        it { should have(0).items }
        subject { Work.all }
        it { should have(0).items }
      }
    end
  end

end

