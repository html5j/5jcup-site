require 'spec_helper'

describe Work do
  describe '.new' do
    context 'given valid attributes' do
      subject { Work.new(:title => 'a', :description => 'a') }
      it { should be_valid }
    end
    context 'given null title' do
      subject { Work.new(:description => 'a') }
      it { should have(1).errors_on(:title) }
    end
  end
end
