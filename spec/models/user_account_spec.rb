require 'spec_helper'

describe UserAccount do
  describe 'find one' do
    before do
      @user = FactoryGirl.create(:user)
    end
    subject { @user }
    it { should have(1).user_accounts }
  end

end
