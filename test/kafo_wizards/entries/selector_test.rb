require 'test_helper'

describe KafoWizards::Entries::SelectorEntry do

  let(:selector) { KafoWizards::Entries::SelectorEntry.new(:nic, :options => {:eth1 => "eth1", :eth0 => "eth0"}) }

  describe "validate" do
    it "allows to select valid option" do
      selector.validate(:eth1).must_equal :eth1
    end

    it "raises error on invalid option" do
      err = proc {
        selector.validate(:bad)
      }.must_raise KafoWizards::ValidationError
      err.message.must_equal "bad is not a valid option"
    end
  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::SelectorEntry.entry_type.must_equal :selector
    end
  end

end
