class ChangeEventRelationship < ActiveRecord::Migration
  def change
  	remove_belongs_to(:events,:user)
  	add_belongs_to(:events,:admin,references: :users, index: true)
  end
end
