require_relative 'abstract'

class PageTest < AbstractTest
 
  def setup
    @p = Page.new
  end

  def test_from_params
    params = {
      'title' => 'Hello World', 
      'category' => 'site', 
      'priority' => 12, 
      'long_text' => 'Loooooooong'
    }

    @p.from_params params

    assert_equal params['title'],     @p.title
    assert_equal params['category'],  @p.category
    assert_equal params['priority'],  @p.priority
    assert_equal params['long_text'], @p.long_text
  end

  def test_generate_slug
    @p.title = 'Hello World'
    @p.generate_slug
    assert_equal 'hello-world', @p.slug
  end
end
