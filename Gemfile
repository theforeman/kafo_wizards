source 'https://rubygems.org'

# Specify your gem's dependencies in kafo_parsers.gemspec
gemspec

# load local gemfile
local_gemfile = File.join(File.dirname(__FILE__), 'Gemfile.local')
self.instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
