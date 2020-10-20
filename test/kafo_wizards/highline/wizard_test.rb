require 'test_helper'
require File.join(File.dirname(__FILE__), 'test_helper')

describe KafoWizards::HighLine::Wizard do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:name) { factory.string(:name, :default_value => 'Any') }
  let(:age) { factory.string(:age) }
  let(:ok) { factory.button(:ok, :label => 'Ok', :default => true) }
  let(:cancel) { factory.button(:cancel, :label => 'Cancel', :default => false, :trigger_validation => false) }
  let(:wizard) { setup_highline_wizard('Header', :description => 'Description', :interactive => false) }

  describe 'default_renderers' do

    it 'has the default renderers set' do
      wizard.class.default_renderers.keys.must_include :string_or_file
      wizard.class.default_renderers.keys.must_include :string
      wizard.class.default_renderers.keys.must_include :abstract
      wizard.class.default_renderers.keys.must_include :password
      wizard.class.default_renderers.keys.must_include :button
      wizard.class.default_renderers.keys.must_include :boolean
      wizard.class.default_renderers.keys.must_include :selector
    end
  end

  describe 'execute_menu' do
    let(:wizard_output) do
      input.puts '1'
      input.rewind
      wizard.entries = [name, cancel, ok]
      wizard.interactive = true
      wizard.execute_menu
      highline_output
    end

    it 'prints header' do
      wizard_output.must_match(/Header/)
    end

    it 'prints current values' do
      wizard_output.must_match(/Name: 'Any'/)
    end

    it 'prints description' do
      wizard_output.must_match(/Description/)
    end

    it 'prints choices' do
      out = wizard_output
      out.must_match(/Ok/)
      out.must_match(/Change Name/)
      out.must_match(/Cancel/)
    end

    it "prints the default button first" do
      wizard_output.must_match(/1\. Ok/)
    end

    it "prints the remaining buttons at the end" do
      wizard_output.must_match(/3\. Cancel/)
    end

    it "returns button pressed" do
      input.puts '1'
      input.rewind
      wizard.entries = [name, cancel, ok]
      result = wizard.execute_menu
      result.must_equal :ok
    end

    it "calls the action when selected" do
      input.puts '2' # change name
      input.puts '1' # ok
      input.rewind
      wizard.entries = [name, cancel, ok]
      wizard.renderers[:string].expects(:render_action).returns(nil)
      wizard.execute_menu
    end

    it "re-calls the action when ValidationError occur" do
      input.puts '2' # change name
      input.puts '1' # ok
      input.rewind
      wizard.entries = [name, cancel, ok]
      wizard.renderers[:string].expects(:render_action).twice.raises(KafoWizards::ValidationError).then.returns(nil)
      wizard.execute_menu
    end

    it "handles interrupt in validation_action" do
      input.puts '2' # change name
      input.puts '1' # ok
      input.rewind
      wizard.entries = [name, cancel, ok]
      wizard.renderers[:string].expects(:render_action).raises(Interrupt)
      wizard.execute_menu
    end

    it 'triggers the validation when button with trigger_validation is chosen' do
      input.puts '1' # ok
      input.rewind
      wizard.entries = [factory.button(:ok, :trigger_validation => true)]
      wizard.expects(:validate).returns(nil)
      wizard.execute_menu
    end

    it 'doesnt trigger the validation when button without trigger_validation is chosen' do
      input.puts '1' # ok
      input.rewind
      wizard.entries = [factory.button(:ok, :trigger_validation => false)]
      wizard.expects(:validate).never
      wizard.execute_menu
    end

    it 'handles the validation error' do
      input.puts '1' # ok
      input.puts '3' # cancel
      input.rewind
      wizard.entries = [ok, cancel, factory.string(:name, :required => true)]
      wizard.execute_menu.must_equal :cancel
      highline_output.must_match(/Name must be present/)
    end

    it "triggers hooks" do
      input.puts '1' # ok
      input.rewind
      button = factory.button(:ok, :trigger_validation => false)
      button.expects(:call_pre_hook)
      button.expects(:call_post_hook)
      wizard.entries = [button]
      wizard.execute_menu
    end

  end

  describe 'print_values' do
    it "prints everything but buttons" do
      wizard.entries = [ok, name, age]
      wizard.print_values
      out = highline_output

      out.must_match(/Name: 'Any'/)
      out.must_match(/Age: ''/)
      out.wont_match(/Ok/)
    end

    it 'prints required values with asterisk' do
      wizard.entries = [ok, name, factory.string(:age, :required => true)]
      wizard.print_values
      highline_output.must_match(/\*Age/)

    end
  end

  describe 'render_value' do
    it 'should try value renderer by class of the entry' do
      KafoWizards::HighLine::StringRenderer.any_instance.expects(:render_value).with(name).returns('Any')
      wizard.render_value(name).must_equal 'Any'
    end
  end
end
