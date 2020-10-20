require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::SelectorRenderer do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  let(:renderer) { KafoWizards::HighLine::SelectorRenderer.new }
  let(:entry) { factory.selector(:name, :default_value => :tom, :options => { :tom => 'Tom', :jerry => 'Jerry'}) }

  describe 'render value' do
    it "prints quoted" do
      renderer.render_value(entry).must_equal "'Tom'"
    end

    it "handle non-string" do
      entry = factory.selector(:name, :default_value => nil, :options => { :tom => 'Tom', :jerry => 'Jerry'})
      renderer.render_value(entry).must_equal "''"
    end

    it "renders the value after update" do
      entry.update(:jerry)
      renderer.render_value(entry).must_equal "'Jerry'"
    end
  end

  describe 'render_entry' do
    it "prepends Select" do
      renderer.render_entry(entry).must_equal 'Select Name'
    end
  end

  describe 'render action' do
    before do
      highline_output_setup
      input.puts '2'
      input.rewind
    end

    it 'prints the options' do
      entry.stubs(:update).returns('xxx')
      renderer.render_action(entry)
      out = highline_output
      out.must_match(/Select Name: /)
      out.must_match(/1. Tom/)
      out.must_match(/2. Jerry/)
    end

    it 'should return nil' do
      entry.stubs(:update).returns('xxx')
      renderer.render_action(entry).must_equal nil
    end

    it "should call entry update" do
      entry.expects(:update).with(:jerry).returns(nil)
      renderer.render_action(entry)
    end
  end

end


