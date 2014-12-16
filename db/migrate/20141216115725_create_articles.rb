class CreateArticles < ActiveRecord::Migration
    def change
        create_table :articles do |t|
            t.string :title
            t.string :category
            t.string :short_text
            t.string :long_text
            t.datetime :created_at
            t.datetime :updated_at
        end
    end
end
