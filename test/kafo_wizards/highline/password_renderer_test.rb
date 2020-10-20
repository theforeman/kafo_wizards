require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::PasswordRenderer do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }

  let(:entry) { factory.password(:password) }
  let(:renderer) { KafoWizards::HighLine::PasswordRenderer.new }


  describe 'render value' do
    it "should print stars instead of the password" do
      renderer.render_value(entry).must_match(/\*{10}/)
    end
  end

  describe 'render action' do
    before do
      highline_output_setup
      input.puts 'PASSWORD'
      input.rewind
    end

    it 'should return nil' do
      e = entry
      e.stubs(:update).returns('xxx')
      renderer.render_action(e).must_equal nil
    end

    it "should call entry update" do
      e = entry
      e.expects(:update).with({:password => 'PASSWORD'}).returns(nil)
      renderer.render_action(e)
    end

    it "should ask for Password and does not display the password" do
      e = entry
      e.stubs(:update).returns('xxx')
      renderer.render_action(e)
      out = highline_output
      out.must_match(/Enter new password: \*{8}/)
      out.wont_match(/PASSWORD/)
    end
  end

  describe 'render action with confirmation' do
    let(:entry) { factory.password(:password, :confirmation_required => true) }

    before do
      highline_output_setup
      input.puts 'PASSWORD'
      input.puts 'PASSWORD'
      input.rewind
    end

    it 'should return nil' do
      e = entry
      e.stubs(:update).returns('xxx')
      renderer.render_action(e).must_equal nil
    end

    it "should call entry update" do
      e = entry
      e.expects(:update).with({:password => 'PASSWORD', :password_confirmation => 'PASSWORD'}).returns(nil)
      renderer.render_action(e)
    end

    it "should ask for Password and confirmation and does not display the password" do
      e = entry
      e.stubs(:update).returns('xxx')
      renderer.render_action(e)
      out = highline_output
      out.must_match(/Enter new password: \*{8}/)
      out.must_match(/Re-type new password: \*{8}/)
      out.wont_match(/PASSWORD/)
    end
  end

 end
