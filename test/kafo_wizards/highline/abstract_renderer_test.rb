require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::AbstractRenderer do
  let(:renderer) { KafoWizards::HighLine::AbstractRenderer.new }
  let(:entry) { factory.abstract(:name, :default_value => 'Test') }

  describe "render_action" do
    it "returns nil" do
      renderer.render_action(entry).must_equal nil
    end
  end

end
