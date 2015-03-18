require File.expand_path '../helper.rb', __FILE__

class AppTest < MiniTest::Test

    include Rack::Test::Methods

    def app
        ColloquiumApp
    end

    def test_home
        get '/'
        assert last_response.ok?
        assert last_response.body.include?('IWSM')
    end
end
