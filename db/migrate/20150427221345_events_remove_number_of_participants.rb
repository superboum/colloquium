class EventsRemoveNumberOfParticipants < ActiveRecord::Migration
  def change
    remove_column :events, :number_of_participants
  end
end
