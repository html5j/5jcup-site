require 'spec_helper'

describe User do

  describe '.new' do
    context 'given valid attributes' do
      subject { User.new(:email => 'hal@plants-web.jp', :password => 'password', :name => 'ハル') }
      it { should be_valid }
      its(:name) { eq 'ハル' }
    end
    it { should validate_presence_of(:name) }
  end
end

