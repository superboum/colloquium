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
        #To connect as admin
        user = User.find_by email: "admin@admin.com"
        visit '/login'
        #to fill the form where 'id' is emailSI
        fill_in 'emailSI', :with => user.email
        fill_in "InputPasswordSI", :with => "admin"
        click_button "Sign in"
        #To find CSS content
        page.find('.btn-danger')
        html.include?('admin@admin.com')
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
        visit '/admin'
        page.find('.btn-danger')
        #To find text in the page
        html.include?('Dashboard')
        html.include?('Dashboard')
        html.include?('Type')
        html.include?('#{Article.count}')
        html.include?('#{Page.count')
        html.include?('#{User.count')
    end 

    def test_admin_article_list
	#Test if buttons and the list are displayed
        admin_login
        visit '/admin/article'
        Article.all.each do |article|
            html.include?(article.title)
        end
         html.include?('Add a new article')
    end

    def test_admin_article_new
        #Fill the form and create a new article
        admin_login
        visit '/admin'
        html.include?('Summary (max 255 chars)')
        #create a new article, verify if it is the same as the one in the database
	
    end

    def test_article_view
        #Check that your new article is correctly displayed
        test_admin_article_new
        #get '/article/#{article.id}'
    end

    def test_pages
        Page.all.each do |page|
            get '/page/#{page.slug}'
            assert last_response.ok?
            assert last_response.body.include?(page.title)
        end
    end                

end
