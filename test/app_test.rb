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
        assert html.include?('admin@admin.com')
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
        assert page.find('.btn-danger')
        #To find text in the page
        assert html.include?('Dashboard')
        assert html.include?('Type')
        assert html.include?("#{Article.count}")
        assert html.include?("#{Page.count}")
        assert html.include?("#{User.count}")
    end 

    def test_admin_article_list
	#Test if buttons and the list are displayed
        admin_login
        visit '/admin/article'
        Article.all.each do |article|
            assert html.include?(article.title)
        end
         html.include?('Add a new article')
    end

    def test_admin_article_new
        #Fill the form and create a new article
        tmp = Article.new
        tmp.title = "un titre normal"
        tmp.category = "Une catégorie"
        tmp.short_text = "Le petit texte"
        tmp.long_text = "et le grand"
        admin_login
        visit '/admin/article/new'
        html.include?('Summary (max 255 chars)')
        fill_in 'title', :with => tmp.title
        fill_in 'category', :with => tmp.category
        fill_in 'short_text', :with => tmp.short_text
        fill_in 'long_text', :with => tmp.long_text
        click_button "Publish"
        a = Article.find_by_title(tmp.title)
        a_id = a.id
        visit "/article/#{a_id}"
        assert html.include?(tmp.title)        
        Article.find_by_title(tmp.title).destroy
    end

    def test_article_view
        #Check that your new article is correctly displayed
        test_admin_article_new
        #get '/article/#{article.id}'
    end

    def test_pages
        Page.all.each do |page|
            get "/page/#{page.slug}"
            assert last_response.ok?
            assert last_response.body.include?(page.title)
        end
    end                

end
