require 'test_helper'

describe KafoWizards::Entries::ButtonEntry do

  let(:button) { KafoWizards::Entries::ButtonEntry.new(:ok, :label => 'Okay', :default => true) }

  it 'uses name as a value' do
    button.value.must_equal :ok
  end

  it 'has trigger_validation? set by default' do
    button.trigger_validation?.must_equal true
  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::ButtonEntry.entry_type.must_equal :button
    end
  end

end
