module KafoWizards
  module HighLine

    class PasswordRenderer < StringRenderer
      def render_value(entry)
        "#{::HighLine.color("**********", :blue)}"
      end

      def render_action(entry)
        password = ask("Enter new password: ") { |q| q.echo = "*" }
        if !entry.confirmation_required?
          entry.update(:password => password)
        else
          password_confirmation = ask("Re-type new password: ") { |q| q.echo = "*" }
          entry.update(:password => password, :password_confirmation => password_confirmation)
        end
        nil
      end
    end

    # register renderer to the highline wizard
    Wizard.register_default_renderer :password, KafoWizards::HighLine::PasswordRenderer.new
  end
end
