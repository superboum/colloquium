require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

#Unit tests
require_relative 'unit/article'
require_relative 'unit/page'
require_relative 'unit/user'
require_relative 'unit/meal'
 require_relative 'unit/event'

#Functionnal tests
require_relative 'functionnal/article'
require_relative 'functionnal/event'
