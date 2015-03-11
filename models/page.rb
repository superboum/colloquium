require 'sinatra/activerecord'

class Page < ActiveRecord::Base
    def generateSlug(ec)
      ec.slug = ec.title.split(' ').join('-').capitalize
    end
end
