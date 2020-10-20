require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require "mocha/minitest"

require 'kafo_wizards'

HighLine.use_color = false

def factory
  KafoWizards::Factory.new
end
