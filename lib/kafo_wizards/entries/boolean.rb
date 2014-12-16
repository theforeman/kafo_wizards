module KafoWizards::Entries

  class BooleanEntry < AbstractEntry

    def initialize(name, options={})
      super(name, options)
      @value = @default_value ? true : false
    end

    def self.entry_type
      :boolean
    end

  end
end
