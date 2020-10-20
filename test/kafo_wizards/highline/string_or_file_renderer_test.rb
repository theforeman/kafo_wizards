require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')
require 'tempfile'

describe KafoWizards::HighLine::StringOrFileRenderer do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  let(:entry) { factory.string_or_file(:description, :default_value => 'ABCDEFG'*10) }
  let(:renderer) { KafoWizards::HighLine::StringOrFileRenderer.new }


  describe 'render value' do
    it "prints text shortened on one line" do
      renderer.render_value(entry).must_match(/\.\.\./)
    end

    it 'prints lenght' do
      renderer.render_value(entry).must_match(/(70 bytes)/)
    end

    it 'prints empty string for nil' do
      entry = factory.string_or_file(:description)
      renderer.render_value(entry).must_equal "'' (0 bytes)"
    end

  end

  describe 'render action' do
    before do
      highline_output_setup
      input.puts 'Text'
      input.rewind
    end

    it 'accepts text and calls update with it' do
      e = entry
      e.expects(:update).with('Text').returns(nil)
      renderer.render_action(e)
    end

    it 'accepts file name and calls update with its content' do
      e = entry
      e.expects(:update).with('Text').returns(nil)
      file = Tempfile.new('text.txt')
      begin
        file.write('Text')
        file.rewind
        input.puts(file.path)
        input.rewind
        renderer.render_action(e)
      ensure
         file.close
         file.unlink   # deletes the temp file
      end
    end

    it 'returns nil' do
      e = entry
      e.stubs(:update).returns('xxx')
      renderer.render_action(e).must_equal nil
    end
  end

end
