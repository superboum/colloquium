class CreateReview < ActiveRecord::Migration
  def up
      create_table :reviews do |t|        
          t.integer :validator_id
          t.integer :lecturer_id
          t.string :name
          t.text :general_info
          t.column :state, :integer, default: 0
          t.datetime :created_at
          t.datetime :updated_at
      end

    add_index :reviews, :validator_id
    add_index :reviews, :lecturer_id
  end

end
