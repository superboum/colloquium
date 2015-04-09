class RelationReviewproposition < ActiveRecord::Migration
  def change
    remove_column :reviewpropositions, :reviews_id
    add_reference :reviewpropositions, :review, references: :reviews, :index => true
  end
end
