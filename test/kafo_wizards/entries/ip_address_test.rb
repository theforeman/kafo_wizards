require 'test_helper'

describe KafoWizards::Entries::IPAddressEntry do

  let(:ip) { KafoWizards::Entries::IPAddressEntry.new(:ip)}

  it "inherits from StringEntry" do
    ip.display_type(true).must_include :string
  end

  describe "validate" do
    it "accepts valid ip address" do
      res = ip.validate('127.0.0.1')
      res.must_match '127.0.0.1'
    end

    it 'raises ValidationError when the ip is invalid' do
      proc {
        ip.validate('127001')
      }.must_raise KafoWizards::ValidationError
    end
  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::IPAddressEntry.entry_type.must_equal :ip_address
    end
  end

end
