require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::StringRenderer do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  let(:renderer) { KafoWizards::HighLine::StringRenderer.new }
  let(:entry) { factory.string(:name, :default_value => 'Test', :description => 'Descr') }

  describe 'render value' do
    it "prints quoted" do
      renderer.render_value(entry).must_equal "'Test'"
    end

    it "handle non-string" do
      entry = factory.string(:name, :default_value => nil)
      renderer.render_value(entry).must_equal "''"
    end
  end

  describe "render entry" do
    it "prepends 'Change'" do
      renderer.render_entry(entry).must_equal "Change Name"
    end
  end

  describe "render_action" do
    before :each do
      highline_output_setup
      input.puts "Value"
      input.rewind
    end

    it "returns nil" do
      renderer.render_action(entry).must_equal nil
    end

    it 'updates the value' do
      entry.expects(:update).with('Value').returns(nil)
      renderer.render_action(entry)
    end

    it 'asks for a new value' do
      renderer.render_action(entry)
      highline_output.must_match(/New value for Name:/)
    end

    it 'prints the entry description' do
      renderer.render_action(entry)
      highline_output.must_match(/Descr/)
    end
  end
end
