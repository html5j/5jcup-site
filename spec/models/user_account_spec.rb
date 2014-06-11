require 'spec_helper'

describe UserAccount do
  describe 'find one' do
    before do
      @fbuser = FactoryGirl.create(:fbuser)
    end
    subject { @fbuser }
    it { should have(1).user_accounts }
  end

end
