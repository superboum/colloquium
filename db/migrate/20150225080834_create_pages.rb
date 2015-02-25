class CreatePages < ActiveRecord::Migration
    def change
        create_table :pages do |t|
            t.string :title
            t.string :category
            t.integer :priority
            t.string :author
            t.string :short_text
            t.text :long_text
            t.string :version
            t.datetime :created_at
            t.datetime :updated_at
        end
    end
end
