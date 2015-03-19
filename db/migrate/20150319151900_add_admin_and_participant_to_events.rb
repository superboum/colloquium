class AddAdminAndParticipantToEvents < ActiveRecord::Migration
  def change
  	add_belongs_to(:events,:user, index: true)

  	create_table :registered_users_to_events, id: false do |t|
      t.belongs_to :event, index: true
      t.belongs_to :user, index: true
    end
  end
end
