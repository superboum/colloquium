require_relative '../helper'

class AbstractTest < Minitest::Test
  include Capybara::DSL
  Capybara.use_default_driver
  Capybara.app = ColloquiumApp
  
  def self.test_order
    :alpha #Order is important here
  end 
end
