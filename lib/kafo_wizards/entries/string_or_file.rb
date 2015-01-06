module KafoWizards::Entries

  class StringOrFileEntry < StringEntry

    def initialize(name, options={})
      super(name, options)
    end

    def self.entry_type
      :string_or_file
    end

  end
end
