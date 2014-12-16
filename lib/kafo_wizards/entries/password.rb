module KafoWizards::Entries

  class PasswordEntry < StringEntry

    def initialize(name, options={})
      super(name, options)
      @confirmation_required = !!options.fetch(:confirmation_required, false)
    end

    def confirmation_required?
      @confirmation_required
    end

    def validate(value)
      if value.length < 8
        raise KafoWizards::ValidationError.new("Password must be at least 8 characters long")
      end
      value
    end

    def update(value)
      if confirmation_required? && (value[:password] != value[:password_confirmation])
        raise KafoWizards::ValidationError.new("Password and confirmation do not match")
      end
      @value = validate(value[:password])
    end

    def self.entry_type
      :password
    end

  end
end
