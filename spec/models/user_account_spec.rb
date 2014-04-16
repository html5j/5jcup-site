require 'spec_helper'

describe UserAccount do
  describe '.all' do
    before do
      user = FactoryGirl.create(:user)
      #FactoryGirl.create(:user_account, user: user)
    end
    subject { User.find(1) }
    it { should have(1).accounts }
  end

end
