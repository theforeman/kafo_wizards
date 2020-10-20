require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require "mocha/setup"

require 'kafo_wizards'

begin
  require 'highline/io_console_compatible'
rescue LoadError
  # Highline 1 doesn't need this
end

HighLine.use_color = false

def factory
  KafoWizards::Factory.new
end
