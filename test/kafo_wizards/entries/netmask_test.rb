require 'test_helper'

describe KafoWizards::Entries::NetmaskEntry do

  let(:netmask) { KafoWizards::Entries::NetmaskEntry.new(:mask)}

  it "inherits from IPAddressEntry" do
    netmask.display_type(true).must_include :ip_address
  end

  describe "validate" do
    it "accepts valid netmask" do
      res = netmask.validate('255.255.255.0')
      res.must_match '255.255.255.0'
    end

    it "accepts valid netmask in bitmask format" do
      res = netmask.validate('127.0.0.1/24')
      res.must_match '255.255.255.0'

    end

    it 'raises ValidationError when the netmask is invalid' do
      err = proc {
        netmask.validate('127001')
      }.must_raise KafoWizards::ValidationError
      err.message.must_equal "127001 is not valid netmask"
    end

    it 'raises ValidationError when the netmask in bitmask mode is invalid' do
      err = proc {
        netmask.validate('127001/56')
      }.must_raise KafoWizards::ValidationError
      err.message.must_equal "127001/56 is not valid netmask (invalid length)"
    end

  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::NetmaskEntry.entry_type.must_equal :netmask
    end
  end

end

