module KafoWizards

  def self.wizard(kind, header, options={})
    HighLine::Wizard.new(header, options)
  end

  class Factory

    def initialize(wizard=nil)
      @wizard = wizard
    end

    def method_missing(meth, *args, &block)
      if @wizard
        args << {} unless args.last.class <= Hash
        args[-1][:parent] = @wizard unless args[-1].has_key?(:parent)
      end

      entry_cls = KafoWizards::Entries::AbstractEntry.descendants.find { |ec| ec.entry_type == meth }
      raise NameError.new "Unknown type of entry (#{meth.to_s})" unless entry_cls
      entry_cls.new(*args)
    end
  end
end
