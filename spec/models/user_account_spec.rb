require 'spec_helper'

describe UserAccount do
  describe 'find one' do
    before do
      Fabricate(:user)
    end
    subject { User.find(1) }
    it { should have(1).user_accounts }
  end

end
