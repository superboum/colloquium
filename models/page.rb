require 'sinatra/activerecord'

class Page < ActiveRecord::Base

  def from_params(params)
    self.title = params['title']
    self.generate_slug
    self.category = params['category']
    self.long_text = params['long_text']
    self.priority = params['priority']
  end

  def generate_slug
    self.slug = self.title.split(' ').join('-').downcase
  end

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
end
