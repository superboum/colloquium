require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

#Unit tests
require_relative 'unit/article'
require_relative 'unit/page'

#Functionnal tests
require_relative 'functionnal/article'
