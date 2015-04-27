require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

#Unit tests
require_relative 'unit/article'

#Functionnal tests
require_relative 'functionnal/article'
