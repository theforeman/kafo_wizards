describe KafoWizards::Entries::PasswordEntry do

  let(:password_c) { KafoWizards::Entries::PasswordEntry.new(:password_c, :confirmation_required => true)}
  let(:password) { KafoWizards::Entries::PasswordEntry.new(:password)}

  it "inherits from StringEntry" do
    password.display_type(true).must_include :string
  end

  describe "update" do
    it "updates the value" do
      password.update(:password => 'password')
      password.value.must_match 'password'
    end

    it "updates the value with confirmation" do
      password_c.update(:password => 'password', :password_confirmation => 'password')
      password_c.value.must_match 'password'
    end

    it "raises ValidationError when the values differ and confirmation is required" do
      proc {
        password_c.update(:password => 'password', :password_confirmation => 'otherpassword')
      }.must_raise KafoWizards::ValidationError
    end

  end

  describe "validate" do
    it "accepts valid password" do
      res = password.validate('password')
      res.must_match 'password'
    end

    it 'raises ValidationError when the password is less then 8 chars long' do
      proc {
        password.validate('xxx')
      }.must_raise KafoWizards::ValidationError
    end
  end

  describe 'class' do
    it 'knows entry type' do
      KafoWizards::Entries::PasswordEntry.entry_type.must_equal :password
    end
  end

end
