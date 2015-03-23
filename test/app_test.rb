require File.expand_path '../helper.rb', __FILE__
require 'capybara'
require 'capybara/dsl'
require 'redcarpet'

class AppTest < MiniTest::Test

    include Rack::Test::Methods
    include Capybara::DSL

    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end

    
    def app
        ColloquiumApp
    end

    def setup
      Capybara.app = ColloquiumApp
    end

    def admin_login
        #Non-fonctional
        user = User.find_by email: "admin@admin.com"
        visit '/login'
        fill_in 'emailSI', :with => user.email
        fill_in "InputPasswordSI", :with => "admin"
        click_button "Sign in"
        page.find('.btn-danger')
      #end
    end

    def test_home
        get '/'
        assert last_response.ok?
        assert last_response.body.include?('IWSM')
        Page.all.each do |page|
           assert last_response.body.include?(page.title)
        end
    end

    def test_admin_home
        #Test if the dashboard is displayed
        admin_login
        get '/admin'
        assert last_response.ok?
        assert last_response.body.include?('Dashboard')
        assert last_response.body.include?('Type')
        assert last_response.body.include?(Article.count)
        assert last_response.body.include?(Page.count)
        assert last_response.body.include?(User.count)
    end

    def test_admin_article_list
	#Test if buttons and the list are displayed
        admin_login
        get '/admin/article'
        assert last_response.ok?
        Article.all.each do |article|
           assert last_response.body.include?(article.title)
        end
        assert last_response.body.include?('Add a new article')
    end

    def test_admin_article_new
        #Fill the form and create a new article
        admin_login
        get '/admin/article/new'
        assert last_response.ok?
        assert last_response.body.include?('Summary (max 255 chars)')
        #create a new article, verify if it is the same as the one in the database
	
    end

    def test_article_view
        #Check that your new article is correctly displayed
        test_admin_article_new
        #get '/article/#{article.id}'
    end

end
