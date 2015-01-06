#!/usr/bin/ruby

require 'kafo_wizards'
require 'awesome_print'


wizard = KafoWizards.wizard(:cli, 'Configure client authentication',
  :description => "Please set a default root password for newly provisioned machines. \n" \
      "If you choose not to set a password, it will be generated randomly. \n" \
      "The password must be a minimum of 8 characters. \n" \
      "You can also set a public ssh key which will be deployed to newly provisioned machines.")

f = wizard.factory
ssh_key_validator = lambda do |value|
  return value if value =~ /\Assh-.* .*( .*)?\Z/
  raise KafoWizards::ValidationError.new("the SSH key seems invalid, make sure the it starts with ssh- and it has no new line characters")
end

wizard.entries = [
  f.string_or_file(:ssh_public_key, :label => 'SSH public key',
    :description => 'You may either use a path to your public key file or enter the whole key (including type and comment)',
    :validators => [ssh_key_validator]),
  f.password(:root_password, :label => 'Root password', :default_value => 'redhat', :confirmation_required => true),
  f.boolean(:show_password, :label => 'Show password', :default_value => true),
  f.button(:ok, :label => 'Proceed with the above values', :default => true),
  f.button(:cancel, :label => 'Cancel Installation', :default => false)
]

res =  wizard.run
ap res.to_s
ap wizard.values
