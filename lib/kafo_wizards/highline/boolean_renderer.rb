module KafoWizards
  module HighLine
    class BooleanRenderer < AbstractRenderer
      def render_value(entry)
        entry.value ? "#{::HighLine.color("Yes", :green)}" : "#{::HighLine.color("No", :red)}"
      end

      def render_entry(entry)
        "Toggle #{entry.label}"
      end

      def render_action(entry)
        entry.update(!entry.value)
        nil
      end
    end

    # register renderer to the highline wizard
    Wizard.register_default_renderer :boolean, KafoWizards::HighLine::BooleanRenderer.new
  end
end
