module KafoWizards::Entries
  class AbstractEntry
    attr_reader :name, :default_value, :value, :label
    attr_accessor :description, :validators, :parent, :post_hook, :pre_hook

    def initialize(name, options={})
      @name = name
      @value = @default_value = options.fetch(:default_value, nil)
      @label = options.fetch(:label, @name.to_s.gsub('_', ' ').capitalize)
      @description = options.fetch(:description, '')
      @validators = options.fetch(:validators, [])
      @required = !!options.fetch(:required, false)
      @parent = options.fetch(:parent, nil)
      @post_hook = options.fetch(:post_hook, nil)
      @pre_hook = options.fetch(:pre_hook, nil)
    end

    def display_type(with_ancestry=false)
      classes = self.class.ancestors.select { |cls| cls.name =~ /Entry\Z/ }
      if with_ancestry
        result = classes.map { |cls| class_to_underscore(cls.name) }
      else
        result = class_to_underscore(classes.first.name)
      end
    end

    def required?
      @required
    end

    def call_post_hook
      post_hook.call(self) if post_hook
    end

    def call_pre_hook
      pre_hook.call(self) if pre_hook
    end

    def update(new_value)
      value = validate(new_value)
      @value = @validators.inject(value) { |result, lam| lam.call(result) }
      @value
    end

    def validate(new_value)
      new_value
    end

    def self.descendants
      @descendants ||= []
    end

    def self.inherited(child)
      superclass.inherited(child) if self < KafoWizards::Entries::AbstractEntry
      descendants << child
    end

    def self.entry_type
      :abstract
    end

    protected

    def class_to_underscore(class_name)
      class_name.split('::').last.gsub(/Entry/, '').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase.to_sym
    end
  end
end
