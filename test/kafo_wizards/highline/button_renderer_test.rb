require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::ButtonRenderer do
  let(:renderer) { KafoWizards::HighLine::ButtonRenderer.new }
  let(:entry) {factory.button(:cancel, :label => 'Cancel installation')}

  describe 'render entry' do
    it "prints the button" do
      renderer.render_entry(entry).must_equal 'Cancel installation'
    end
  end

  describe 'render_action' do
    it 'returns the button name' do
      renderer.render_action(entry).must_equal :cancel
    end
  end
end
