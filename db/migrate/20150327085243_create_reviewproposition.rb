class CreateReviewproposition < ActiveRecord::Migration
  def change
      create_table :reviewpropositions do |t|        
          t.belongs_to :reviews, index: true
          t.string :file
          t.text :lecturer_info
          t.text :validator_comment
          t.datetime :created_at
          t.datetime :updated_at
      end
  end
end
