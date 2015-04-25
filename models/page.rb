require 'sinatra/activerecord'

class Page < ActiveRecord::Base
    def generateSlug
      self.slug = self.title.split(' ').join('-').capitalize
    end

    belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
end
