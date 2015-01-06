require 'highline/import'

module KafoWizards
  module HighLine
    class Wizard < AbstractWizard

      def execute_menu
        begin
          choice = nil
          loop do
            say "\n"
            say ::HighLine.color(header, :yellow) unless header.empty?
            print_values
            say "\n" + description
            choice = print_menu
            break unless choice.nil?
          end
          validate(values) if triggers.include? choice
          choice
        rescue KafoWizards::ValidationError => e
          say ::HighLine.color("\nUnable to procedd due to following error(s):", :red)
          say ::HighLine.color(format_errors(e.messages), :red)
          say "\n"
          retry
        end
      end

      def print_values
        entries.each do |entry|
          max_label_width = 25
          next if (entry.class <= KafoWizards::Entries::ButtonEntry)
          if entry.required?
            label = ::HighLine.color(('*'+entry.label).rjust(max_label_width), :bold, :yellow)
          else
            label = entry.label.rjust(max_label_width)
          end
          say "#{label}: " + render_value(entry)
        end
      end

      def print_menu
        choose do |menu|
          menu.header = ::HighLine.color("\nAvailable actions", :white)
          menu.prompt = 'Your choice: '
          menu.select_by = :index

          sorted_entries.each do |entry|
            menu.choice(render_entry(entry)) do
              begin
                entry.call_pre_hook
                res = render_action(entry)
                entry.call_post_hook
                res
              rescue KafoWizards::ValidationError => e
                say ::HighLine.color("\nValidation error: #{e.message}", :red)
                say "Please, try again... \n\n"
                retry
              rescue Interrupt
                nil
              end
            end
          end
        end
      end


      def render_action(entry)
        call_renderer_for_entry(:render_action, entry)
      end

      def render_value(entry)
        call_renderer_for_entry(:render_value, entry)
      end

      def render_entry(entry)
        call_renderer_for_entry(:render_entry, entry)
      end

      protected
      def sorted_entries
        sorted = { :default => [], :entries => [], :buttons => []}
        sorted = entries.inject(sorted) do |res, entry|
          if entry.class <= KafoWizards::Entries::ButtonEntry
            cat = entry.default? ? :default : :buttons
          else
            cat = :entries
          end
          res[cat] << entry
          res
        end
        sorted[:default] + sorted[:entries] + sorted[:buttons]
      end

      def format_errors(errors)
        errors.map{ |e| "- #{e}"}.join("\n")
      end
    end
  end
end
