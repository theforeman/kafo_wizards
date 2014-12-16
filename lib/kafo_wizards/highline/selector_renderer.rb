module KafoWizards
  module HighLine

    class SelectorRenderer < StringRenderer
      def render_value(entry)
        value = entry.options[entry.value].to_s
        "'#{::HighLine.color(value, :blue)}'"
      end

      def render_entry(entry)
        "Select #{entry.label}"
      end

      def render_action(entry)
        choose do |sel|
          sel.header = ::HighLine.color("Available options", :white)
          sel.prompt = "Select #{entry.label}: "
          sel.select_by = :index
          entry.options.each_pair do |opt, label|
            sel.choice(label) do
              entry.update(opt)
              nil
            end
          end
        end
      end
    end

    # register renderer to the highline wizard
    Wizard.register_default_renderer :selector, KafoWizards::HighLine::SelectorRenderer.new
  end
end
