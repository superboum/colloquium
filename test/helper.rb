ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require 'capybara/dsl'
require 'rack/test'


require_relative '../app'


