require_relative '../helper'

class AbstractTest < Minitest::Test
  include Capybara::DSL

  case ENV['TEST_DRIVER']
  when 'selenium'
    Capybara.default_driver = :selenium
  else
    Capybara.default_driver = :rack_test
  end

  Capybara.use_default_driver
  Capybara.app = ColloquiumApp

  def self.test_order
    :alpha #Order is important here
  end 
end
