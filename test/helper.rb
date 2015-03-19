ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

require File.expand_path '../../app.rb', __FILE__
