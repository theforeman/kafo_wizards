module KafoWizards
  module HighLine
    class StringRenderer < AbstractRenderer

      def render_value(entry)
        "'#{::HighLine.color(entry.value.to_s, :blue)}'"
      end

      def render_entry(entry)
        "Change #{entry.label}"
      end

      def render_action(entry)
        say entry.description if entry.description
        key = ask("New value for #{entry.label}: ")
        entry.update(key.chomp)
        nil
      end
    end
    # register renderer to the highline wizard
    Wizard.register_default_renderer :string, KafoWizards::HighLine::StringRenderer.new
  end
end
