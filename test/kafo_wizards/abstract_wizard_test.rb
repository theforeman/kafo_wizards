require 'test_helper'


describe KafoWizards::AbstractWizard do
  let(:firstname) { KafoWizards::Entries::StringEntry.new(:firstname) }
  let(:lastname) { KafoWizards::Entries::StringEntry.new(:lastname) }
  let(:cancel) {KafoWizards::Entries::ButtonEntry.new(:cancel, :default => false, :trigger_validation => false)}
  let(:ok) {KafoWizards::Entries::ButtonEntry.new(:ok, :default => true)}
  let(:wizard) { KafoWizards::AbstractWizard.new('Set name', :description => 'Description', :interactive => false) }


  it "should have header set" do
    wizard.header.must_equal 'Set name'
  end

  it "should have description set" do
    wizard.description.must_equal 'Description'
  end

  it 'accepts logger to be set' do
    logger = Logger.new(STDERR)
    wizard = KafoWizards::AbstractWizard.new('Set name', :logger => logger)
    wizard.logger.must_equal logger
  end


  it 'sets default logger if not specified' do
    wizard.logger.must_be_kind_of Logger
  end

  describe 'non-interqctive mode' do
    it "returns the default button" do
      wizard.entries = [firstname, lastname, cancel, ok]
      result = wizard.run
      result.must_equal :ok
    end

    it "allows to set entries on the instance" do
      wizard.entries = [firstname, lastname, cancel, ok]
      result = wizard.run
      result.must_equal :ok
    end
  end

  describe 'interactive mode' do
    it "returns the chosen button" do
      wizard.entries = [firstname, lastname, ok]
      wizard.interactive = true
      wizard.stubs(:execute_menu).returns(:ok)

      result = wizard.run
      result.must_equal :ok
    end
  end

  describe 'return values' do
    it 'returns value for entries except buttons' do
      wizard.entries = [firstname, lastname, ok, cancel]
      wizard.run
      wizard.values.must_equal({ :firstname => nil, :lastname => nil })
    end
  end

  describe "entries" do
    it 'allows to add entries after init' do
      wizard.entries = [firstname, lastname, cancel, ok]
      result = wizard.run
      result.must_equal :ok
    end
  end

  describe "renderers" do
    it 'allows to access renderers after init' do
      fake_renderer = { :none => nil }
      wizard.renderers = fake_renderer
      wizard.renderers.must_equal fake_renderer
    end

    it "is initialised with default_renderers" do
      class MyWiz < KafoWizards::AbstractWizard; end
      MyWiz.default_renderers[:my_entry] = :fake
      mw = MyWiz.new('name')
      mw.renderers[:my_entry].must_equal :fake
    end
  end

  describe "register_default_renderer" do
    it "registers renderer" do
      class MyWiz < KafoWizards::AbstractWizard; end
      MyWiz.register_default_renderer :my_entry, :my_renderer
      mw = MyWiz.new('name')
      mw.renderers[:my_entry].must_equal :my_renderer
    end
  end

  describe "triggers" do
    it 'list all buttons with trigger_validation set' do
      wizard.entries = [firstname, ok, cancel]
      wizard.triggers.must_equal [:ok]
    end
  end

  describe "update" do
    it 'updates the entries' do
      wizard.entries = [firstname, lastname, ok]
      wizard.update(:firstname => 'A', :lastname => 'B')
      wizard.values[:firstname].must_equal 'A'
      wizard.values[:lastname].must_equal 'B'
    end
  end

  describe "validate" do
    it 'validates required entries' do
      wizard.entries = [firstname, factory.string(:lastname, :required => true, :default_value => 'Name')]
      wizard.validate(wizard.values)
    end

    it 'fails when required entries are empty' do
      wizard.entries = [firstname, factory.string(:lastname, :required => true)]
      proc { wizard.validate(wizard.values) }.must_raise KafoWizards::ValidationError
    end

    it 'calls custom validators' do
      wizard.entries = [firstname]
      wizard.validators << lambda { |value| raise KafoWizards::ValidationError.new('Custom') }
      proc { wizard.validate(wizard.values) }.must_raise KafoWizards::ValidationError
    end

    it 'collects ValidationErrors' do
      wizard.entries = [firstname, factory.string(:lastname, :required => true)]
      wizard.validators << lambda { |value| raise KafoWizards::ValidationError.new(['Error1', 'Error2']) }
      err = proc { wizard.validate(wizard.values) }.must_raise KafoWizards::ValidationError
      err.messages.must_equal ["Lastname must be present", "Error1", "Error2"]
    end
  end

  describe "factory" do
    it "returns factory producing entries bound to the wizard" do
      factory = wizard.factory
      factory.must_be_kind_of KafoWizards::Factory
      str = factory.string(:str)
      str.parent.must_equal wizard
    end
  end
end
