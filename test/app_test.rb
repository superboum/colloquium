require File.expand_path '../helper.rb', __FILE__

class AppTest < MiniTest::Unit::TestCase

    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    def test_home
        get '/'
        assert last_response.ok?
        assert last_response.body.include?('<h1>ScienceConf</h1>')
    end
end
