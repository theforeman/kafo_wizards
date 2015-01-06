module KafoWizards::Entries
  class StringEntry < AbstractEntry
    def initialize(name, options={})
      super(name, options)
    end

    def self.entry_type
      :string
    end

  end
end
