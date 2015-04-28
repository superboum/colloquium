require_relative 'abstract'

class EventTest < AbstractTest

  def test_001_home_page
    visit '/'
    assert page.has_content?('News')
    assert page.has_content?('Events')
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
    find('a[href="/admin/event"]').click
    first(:link, 'Add a new event').click
    fill_in 'name', :with => "Event test"
    fill_in 'short_text', :with => "This is a joke :)"
    fill_in 'long_text', :with => "Everything is __cool__"
    check ('Add a form to your event')
    click_on('Publish')
  end

  
  def test_005_add_felt
    fill_in 'question', :with => "Event felt"
    choose("bool")
    assert page.has_content?('Add a form to your event')
    click_on('Publish')
    assert page.has_content?('Event test')
  end

  def test_006_show_event_as_public
    click_link('Home')
    assert page.has_content?("Event test")
  end

  def test_007_edit_article
    click_on('admin')
    find('a[href="/admin/event"]').click
    all('a[href^="/admin/event/edit"]').last.click
    fill_in 'name', :with => "Albert Einstein"
    fill_in 'short_text', :with => "Great man"
    fill_in 'long_text', :with => "> So amazing"
    click_on('Publish')
  end  
  
  def test_008_enable
    visit '/profile/event'
    assert page.has_no_link?('Albert Einstein')
    visit '/admin/event'
    all('a[href^="/admin/event/edit"]').last.click
    check('Enable registration')
    click_on('Publish')
    visit '/profile/event'
    assert page.has_link?('Albert Einstein')
    

  end



  def test_100_delete_article
    click_on('admin')
    find('a[href="/admin/event"]').click
    all('a[href^="/admin/event/delete"]').last.click
    click_on('Delete')
  end
end
