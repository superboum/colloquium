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

    assert_equal params['title'], @a.title
  end
end
