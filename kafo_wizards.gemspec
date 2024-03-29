# coding: utf-8
require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'kafo_wizards', 'version')

Gem::Specification.new do |spec|
  spec.name          = "kafo_wizards"
  spec.version       = KafoWizards::VERSION
  spec.authors       = ["Martin Bačovský"]
  spec.email         = ["mbacovsk@redhat.com"]
  spec.summary       = %q{Wizard like interfaces in terminal}
  spec.description   = %q{This gem helps to create wizard like interfaces in terminal applications, has support for nesting and value validation}
  spec.homepage      = "https://github.com/theforeman/kafo_wizards"
  spec.license       = "GPL-3.0+"

  spec.files         = `git ls-files`.split($/)
  spec.files         = Dir['lib/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.md']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.7', '< 4'

  spec.add_development_dependency "bundler", ">= 1.5", "< 3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 4.0"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "mocha", "~> 2.1"
  spec.add_development_dependency "ci_reporter", "~> 1.0"

  spec.add_dependency 'highline', '< 3'
end
