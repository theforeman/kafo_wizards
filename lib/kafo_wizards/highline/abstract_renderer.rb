module KafoWizards
  module HighLine
    class AbstractRenderer
      def render_value(entry)
      end

      def render_entry(entry)
      end

      def render_action(entry)
      end
    end

    # register renderer to the highline wizard
    Wizard.register_default_renderer :abstract, KafoWizards::HighLine::AbstractRenderer.new
  end
end
