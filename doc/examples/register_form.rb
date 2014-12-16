#!/usr/bin/ruby

require 'kafo_wizards'
require 'awesome_print'

wizard = KafoWizards.wizard(:cli, 'Register',
  :description => "Please provide credentials for a new account")

f = wizard.factory

wizard.entries = [
  f.string(:username, :default_value => 'admin', :required => true),
  f.password(:password, :label => 'Password', :confirmation_required => true, :required => true),
  f.button(:register, :label => 'Register new account', :default => true),
  f.button(:cancel, :default => false, :trigger_validation => false)
]

res = wizard.run

puts "Submitted with #{res.ai}"
puts "Values: #{wizard.values.ai}"
