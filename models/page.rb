require 'sinatra/activerecord'

class Page < ActiveRecord::Base
    def generateSlug
      self.slug = self.title.split(' ').join('-').capitalize
    end
end
