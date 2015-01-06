# KafoWizards


With this gem it is possible to define form or wizard and display it to the user using one of the defined backends. The form definition is independent on the chosen backend so it can be changed freely. Currently only command line (highline) backend is implemented, YAD or web based backend is planed.

Warning: The code is still very unstable

## Installation

Add this line to your application's Gemfile:

    gem 'kafo_wizards'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kafo_wizards

## Usage

```ruby
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
```

will render as:

```text
Register
                *Username: 'admin'
                *Password: **********

Please provide credentials for a new account

Available actions:
1. Register new account
2. Change Username
3. Change Password
4. Cancel
Your choice: 3
Enter new password: ********
Re-type new password: ********

Register
                *Username: 'admin'
                *Password: **********

Please provide credentials for a new account

Available actions:
1. Register new account
2. Change Username
3. Change Password
4. Cancel
Your choice: 1
Submitted with :register
Values: {
    :username => "admin",
    :password => "changeme"
}

```

For more examples look into `doc/examples/` directory.

# License

This project is licensed under the GPLv3+.
