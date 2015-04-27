require_relative 'abstract'

class ArticleTest < AbstractTest
  def setup
    @a = Article.new
  end

  def test_from_params
    params = {
      'title' => 'Hello World', 
      'category' => 'site', 
      'short_text' => 'this is short', 
      'long_text' => 'Loooooooong'
    }

    @a.from_params params

    assert_equal params['title'],       @a.title
    assert_equal params['category'],    @a.category
    assert_equal params['short_text'],  @a.short_text
    assert_equal params['long_text'],   @a.long_text
  end
end
