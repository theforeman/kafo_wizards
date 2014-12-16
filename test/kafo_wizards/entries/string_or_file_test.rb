describe KafoWizards::Entries::StringOrFileEntry do

  let(:text) { KafoWizards::Entries::StringOrFileEntry.new(:text)}

  it "inherits from StringEntry" do
    text.display_type(true).must_include :string
  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::StringOrFileEntry.entry_type.must_equal :string_or_file
    end
  end

end
