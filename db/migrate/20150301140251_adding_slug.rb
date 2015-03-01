class AddingSlug < ActiveRecord::Migration
  def change
    add_column :articles, :slug, :string
    add_column :pages, :slug, :string
  end
end
