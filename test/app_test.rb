require File.expand_path '../helper.rb', __FILE__

class AppTest < MiniTest::Unit::TestCase

    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    def test_hello_world
        get '/'
        assert last_response.ok?
        assert_equal "Hello world!", last_response.body
    end
end
