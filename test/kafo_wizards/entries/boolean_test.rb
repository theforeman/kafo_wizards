require 'test_helper'

describe KafoWizards::Entries::BooleanEntry do

  it 'should convert default value to bool' do
    entry = KafoWizards::Entries::BooleanEntry.new(:yes_no, :default_value => 1)
    entry.value.must_equal true
  end

  it 'should convert default value to bool when nil' do
    entry = KafoWizards::Entries::BooleanEntry.new(:yes_no, :default_value => nil)
    entry.value.must_equal false
  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::BooleanEntry.entry_type.must_equal :boolean
    end
  end

end
