HighLine.use_color = false

def highline_output_setup
  $terminal.instance_variable_set '@input', input
  $terminal.instance_variable_set '@output', output
end

def setup_highline_wizard(header='Header', options={})
  highline_output_setup
  wizard = KafoWizards::HighLine::Wizard.new(header, options)
  wizard
end

def highline_output
  output.rewind
  output.read
end

def render_highline_entry_value(entry)
  wizard = setup_highline_wizard
  wizard.entries = [entry]
  wizard.print_values
  highline_output
end

def render_highline_entry(entry)
  wizard = setup_highline_wizard
  wizard.entries = [entry]
  wizard.render_entry(entry)
end

def execute_highline_entry_action(entry)
  wizard = setup_highline_wizard
  wizard.entries = [entry]
  wizard.render_action(entry)
end

