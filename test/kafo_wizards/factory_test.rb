require 'test_helper'

describe 'KafoWizards::Factory' do

  let(:factory) { KafoWizards::Factory.new }

  it "creates ButtonEntry for button" do
    entry = factory.button(:ok, :label => 'Label')
    entry.must_be_instance_of KafoWizards::Entries::ButtonEntry
    entry.label.must_equal 'Label'
  end

  it "creates PasswordEntry for password" do
    entry = factory.password(:root_password)
    entry.must_be_instance_of KafoWizards::Entries::PasswordEntry
  end

  it "creates BooleanEntry for boolean" do
    entry = factory.boolean(:yes_no)
    entry.must_be_instance_of KafoWizards::Entries::BooleanEntry
  end

  it "creates StringOrFileEntry for string_or_file" do
    entry = factory.string_or_file(:data)
    entry.must_be_instance_of KafoWizards::Entries::StringOrFileEntry
  end

  it "creates StringEntry for string" do
    entry = factory.string(:name, :default_value => 'x')
    entry.must_be_instance_of KafoWizards::Entries::StringEntry
    entry.label.must_equal 'Name'
    entry.value.must_equal 'x'
  end

  it "creates IPAddressEntry for ip_address" do
    entry = factory.ip_address(:ip, :default_value => '127.0.0.1')
    entry.must_be_instance_of KafoWizards::Entries::IPAddressEntry
  end

  it "creates NetmaskEntry for netmask" do
    entry = factory.netmask(:mask)
    entry.must_be_instance_of KafoWizards::Entries::NetmaskEntry
  end

  it "creates SelectorEntry for selector" do
    entry = factory.selector(:mask)
    entry.must_be_instance_of KafoWizards::Entries::SelectorEntry
  end

  it "raises NameError for unknown type" do
    error = assert_raises(NameError) do
      factory.nonsense(:sth)
    end
    expected_error_message = "Unknown type of entry (nonsense)"
    assert_match expected_error_message, error.message
  end


  describe "parent setting" do
    let(:wizard) { KafoWizards::AbstractWizard.new("Header") }
    let(:factory) { KafoWizards::Factory.new(wizard) }
    it "sets parent when created with wizard" do
      str = factory.string(:name)
      str.parent.must_equal wizard
    end

    it "sets parent in complex entries when created with wizard" do
      str = factory.string(:name, :label => 'NAME')
      str.parent.must_equal wizard
      str.label.must_equal 'NAME'
    end

    it "does not set parent when created with wizard but parent already set" do
      str = factory.string(:name, :parent => "parent")
      str.parent.wont_equal wizard
    end
  end
end

describe 'KafoWizards.wizard' do

  it 'creates HighLine Wizard for :cli' do
    wizard = KafoWizards.wizard(:cli, 'Wizard', :description => 'Text')
    wizard.must_be_instance_of KafoWizards::HighLine::Wizard
    wizard.description.must_equal 'Text'
  end

  it 'creates HighlineWizard for :highline' do
    wizard = KafoWizards.wizard(:highline, 'Wizard')
    wizard.must_be_instance_of KafoWizards::HighLine::Wizard
  end
end
