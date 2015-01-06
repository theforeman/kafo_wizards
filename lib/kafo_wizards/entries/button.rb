module KafoWizards::Entries

  class ButtonEntry < AbstractEntry

    attr_reader :name

    def initialize(name, options={})
      super(name, options)
      @default = !!options.fetch(:default, true)
      @value = name
      @trigger_validation = !!options.fetch(:trigger_validation, true)
    end

    def default?
      @default
    end

    def trigger_validation?
      @trigger_validation
    end

    def self.entry_type
      :button
    end

  end
end
