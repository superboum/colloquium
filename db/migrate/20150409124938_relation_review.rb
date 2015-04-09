class RelationReview < ActiveRecord::Migration
  def change
    remove_column :reviews, :validator_id
    add_reference :reviews, :validator, references: :users, :index => true
    
    remove_column :reviews, :lecturer_id
    add_reference :reviews, :lecturer, references: :users, :index => true
  end
end
