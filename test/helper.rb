ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require 'capybara/dsl'
require 'rack/test'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

require_relative '../app'


