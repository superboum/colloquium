require_relative 'abstract'

class ArticleTest < AbstractTest

  def test_001_home_page
    visit '/'
    assert page.has_content?('IWSM')
  end

  def test_002_admin_auth
    if (!page.has_content?('admin@admin.com'))
      click_link("Sign in / Sign up")
      fill_in 'emailSI', :with => "admin@admin.com"
      fill_in "InputPasswordSI", :with => "admin"
      click_button "Sign in"
      assert page.find('.btn-danger')
      assert page.has_content?('admin@admin.com')
    end
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
    fill_in 'title', :with => "La relativité restreinte"
    fill_in 'category', :with => "Physique"
    fill_in 'short_text', :with => "This is a joke :)"
    fill_in 'long_text', :with => "Everything is __cool__"
    click_on('Publish')
  end

  def test_005_show_article
    click_on('Home')
    assert page.has_content?('La relativité restreinte')
    first(:link, 'Read more').click
    assert page.has_content?('La relativité restreinte')
    assert page.has_content?('This is a joke :)')
    assert page.has_content?('Everything is cool')
  end

  def test_006_edit_article
    click_on('admin')
    find('a[href="/admin/article"]').click
    all('a[href^="/admin/article/edit"]').last.click
    fill_in 'title', :with => "Albert Einstein"
    fill_in 'category', :with => "History"
    fill_in 'short_text', :with => "Great man"
    fill_in 'long_text', :with => "> So amazing"
    click_on('Publish')
  end  
  
  def test_007_show_modified_article
    click_on('Home')
    assert page.has_content?('Albert Einstein')
    first(:link, 'Read more').click
    assert page.has_content?('Albert Einstein')
    assert page.has_content?('History')
    assert page.has_content?('So amazing')
  end
  
  def test_008_delete_article
    click_on('admin')
    find('a[href="/admin/article"]').click
    all('a[href^="/admin/article/delete"]').last.click
    click_on('Delete')
  end
end
