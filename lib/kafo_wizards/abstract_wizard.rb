require 'logger'

module KafoWizards
  class AbstractWizard
    attr_reader :header, :description, :logger
    attr_accessor :entries, :renderers, :interactive, :validators
    def initialize(header, options = {})
      @header = header
      @interactive = options.fetch(:interactive, true)
      @entries = options.fetch(:entries, [])
      @description = options.fetch(:description, '')
      @renderers = options.fetch(:renderers, self.class.default_renderers)
      @validators = options.fetch(:validators, [])
      @validators << lambda { |values| check_required_entries(values) }
      @logger = options.fetch(:logger) do |l|
        logger = Logger.new(STDERR)
        logger.level = Logger::ERROR
        logger
      end
    end

    def run
      if @interactive
        choice = execute_menu
      else
        choice = nil
        default_button = buttons.find { |b| b.default? }
        choice = default_button.name if default_button
      end
      choice
    end

    def execute_menu
    end

    def buttons
      @entries.select { |e| e.class >= KafoWizards::Entries::ButtonEntry }
    end

    def triggers
      buttons.inject([]) do |b_names, b|
        b_names << b.name if b.trigger_validation?
        b_names
      end
    end

    def values
      @entries.inject({}) do |vals, entry|
        vals[entry.name] = entry.value unless entry.class >= KafoWizards::Entries::ButtonEntry
        vals
      end
    end

    def update(values = {})

      entries.each do |entry|
        entry.update(values[entry.name]) unless values[entry.name].nil?
      end
    end

    def validate(values)
      errors = []
      validated = @validators.inject(values) do |result, lam|
        begin
          lam.call(result)
        rescue ValidationError => e
          errors += e.messages
          result
        end
      end
      raise ValidationError.new errors unless errors.empty?
      validated
    end

    def factory
      Factory.new(self)
    end

    def self.default_renderers
      @default_renderers ||= {}
    end

    def self.register_default_renderer(display_type, renderer)
      default_renderers[display_type] = renderer
    end

    protected

    def check_required_entries(values)
      messages = entries.inject([]) do |messages, e|
        messages << "#{e.label} must be present" if e.required? && values[e.name].nil?
        messages
      end
      raise ValidationError.new(messages) unless messages.empty?
      values
    end

    def call_renderer_for_entry(render_method, entry)
      display_type = entry.display_type(true).find { |dt| @renderers.has_key?(dt) && @renderers[dt].respond_to?(render_method) }
      @renderers[display_type].send(render_method, entry) if display_type
    end

  end
end
