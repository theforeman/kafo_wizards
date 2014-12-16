module KafoWizards
  module HighLine
    class ButtonRenderer < AbstractRenderer
      def render_entry(entry)
        color = entry.default? ? :green : :red
        "#{::HighLine.color(entry.label, color)}"
      end

      def render_action(entry)
        entry.name
      end
    end

    # register renderer to the highline wizard
    Wizard.register_default_renderer :button, KafoWizards::HighLine::ButtonRenderer.new
  end
end
