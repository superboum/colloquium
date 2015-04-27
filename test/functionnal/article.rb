require_relative 'abstract'

class ArticleTest < AbstractTest

  def test_001_home_page
    visit '/'
    assert page.has_content?('IWSM')
  end

  def test_002_admin_auth
    click_link("Sign in / Sign up")
    fill_in 'emailSI', :with => "admin@admin.com"
    fill_in "InputPasswordSI", :with => "admin"
    click_button "Sign in"
    assert page.find('.btn-danger')
    assert page.has_content?('admin@admin.com')
  end

  def test_003_dashboard
    click_on('admin')
    assert page.find('.btn-danger')
    assert page.has_content?('Dashboard')
    assert page.has_content?('Type')
  end

  def test_004_add_article
    find('a[href="/admin/article"]').click
    first(:link, 'Add a new article').click
  end
end

#class CMSTest < MiniTest::Test


  #Capybara.use_default_driver

  #def setup
    #Capybara.app = ColloquiumApp
  #end


  #test "home" do
    #visit '/'
    #assert page.has_content?('IWSM')
  #end

#  def test_admin_login
    #visit '/'
    #click_link("Sign in / Sign up")
    #fill_in 'emailSI', :with => "admin@admin.com"
    #fill_in "InputPasswordSI", :with => "admin"
    #click_button "Sign in"
    #assert page.find('.btn-danger')
    #assert page.has_content?('admin@admin.com')
  #end


  #def test_admin_home
    #visit '/'
    #click_on('admin')
    #assert page.find('.btn-danger')
    ##To find text in the page
    #assert page.has_content?('Dashboard')
    #assert page.has_content?('Type')
  #end 

  #def test_admin_add_article
    #visit '/'
    #click_on('admin')
    #click_on('Articles')
    #click_on('Add a new article')
     
  #end

  #def test_admin_article_new
  ##Fill the form and create a new article
  #new_article
  #a = Article.find_by_title($tmp_article.title)
  #visit "/article/#{a.id}"
  #assert html.include?($tmp_article.long_text)        
  #a.destroy
  #end

  #def test_pages
  #admin_login
  #visit '/admin/page/new'
  #html.include?('(Markdown Syntax is allowed)')
  #fill_in 'title', :with => "In test_pages"
  #fill_in 'long_text', :with => "The text of the page"
  #click_button "Publish"
  #p = Page.find_by_title("In test_pages")
  #Page.all.each do |page|
  #visit "/page/#{page.slug}"
  ##assert last_response.ok?
  ##assert last_response.body.include?(page.title)
  ##assert last_response.body.include?(page.long_text)
  #end
  #p.destroy
  #p = Page.find_by_title("In test_pages")
  #assert p == nil
  #end                

#end
