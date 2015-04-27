require 'sinatra/activerecord'

class Article < ActiveRecord::Base
  def from_params(params)
    self.title = params['title']
    self.category = params['category']
    self.short_text = params['short_text']
    self.long_text = params['long_text']
  end
end
