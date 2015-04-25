class PageAuthorToReference < ActiveRecord::Migration
  def change
    remove_column :pages, :author
    add_reference :pages, :author, references: :users, :index => true
  end
end