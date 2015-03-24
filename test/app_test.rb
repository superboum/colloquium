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
    

    $tmp_article = Article.new
    $tmp_article.title = "un titre normal"
    $tmp_article.category = "Une catégorie"
    $tmp_article.short_text = "Le petit texte"
    $tmp_article.long_text = "et le grand"
    
    def new_page
        p = Page.new
        p.title = "A title to try"
        p.generateSlug()
        p.author = "John Doe"
        p.long_text = "A lot of content in this page"
        p.priority = 2
        p.save
    end
    
    
    def new_article
        admin_login
        visit '/admin/article/new'
        html.include?('Summary (max 255 chars)')
        fill_in 'title', :with => $tmp_article.title
        fill_in 'category', :with => $tmp_article.category
        fill_in 'short_text', :with => $tmp_article.short_text
        fill_in 'long_text', :with => $tmp_article.long_text
        click_button "Publish"
    end

    def admin_login
        #To connect as admin
        user = User.find_by email: "admin@admin.com"
        visit '/login'
        #to fill the form where 'id' is emailSI
        fill_in 'emailSI', :with => user.email
        fill_in "InputPasswordSI", :with => "eukfzhgeofiuhzefefzsef"
        click_button "Sign in"
        assert not(html.include?('admin@admin.com'))
        visit '/login'
        #to fill the form where 'id' is emailSI
        fill_in 'emailSI', :with => user.email
        fill_in "InputPasswordSI", :with => "admin"
        click_button "Sign in"
        #To find CSS content
        assert page.find('.btn-danger')
        #to find text in body
        assert html.include?('admin@admin.com')
      #end
    end

    def test_home
        get '/'
        assert last_response.ok?
        assert last_response.body.include?('IWSM')
        pages = Page.all
        if pages == nil
            new_page
        end
        pages.each do |page|
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
        articles = Article.all
        if articles == nil
            new_article
        end
        visit '/admin/article'
        articles.each do |article|
            assert html.include?(article.title)
        end
         assert html.include?('Add a new article')
    end

    def test_admin_article_new
        #Fill the form and create a new article
        new_article
        a = Article.find_by_title($tmp_article.title)
        visit "/article/#{a.id}"
        assert html.include?($tmp_article.long_text)        
        a.destroy
    end

    def test_pages
        admin_login
        visit '/admin/page/new'
        html.include?('(Markdown Syntax is allowed)')
        fill_in 'title', :with => "In test_pages"
        fill_in 'long_text', :with => "The text of the page"
        click_button "Publish"
        p = Page.find_by_title("In test_pages")
        Page.all.each do |page|
            get "/page/#{page.slug}"
            assert last_response.ok?
            assert last_response.body.include?(page.title)
            assert last_response.body.include?(page.long_text)
        end
        p.destroy
    end                

end
