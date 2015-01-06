require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::BooleanRenderer do
  let(:renderer) { KafoWizards::HighLine::BooleanRenderer.new }

  let(:entry) { factory.boolean(:check, :default_value => true) }
  let(:entry_with_false) { factory.boolean(:check, :default_value => false) }

  describe 'render_value' do
    it "prints Yes for true" do
      renderer.render_value(entry).must_equal 'Yes'
    end

    it "prints No for false" do
      renderer.render_value(entry_with_false).must_equal 'No'
    end
  end

  describe 'render_entry' do
    it "prepends Toggle" do
      renderer.render_entry(entry).must_equal 'Toggle Check'
    end
  end

  describe 'render_action' do
    it 'returns nil' do
      e = entry
      e.stubs(:update).returns(nil)
      renderer.render_action(e).must_equal nil
    end

    it "calls entry update" do
      e = entry
      e.expects(:update).with(false).returns(nil)
      renderer.render_action(entry)
    end
  end
end
