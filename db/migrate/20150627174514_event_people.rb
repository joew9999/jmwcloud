class EventPeople < ActiveRecord::Migration
  def change
    remove_column :events, :person_id

    create_table :event_people do |t|
      t.integer :event_id
      t.integer :person_id

      t.timestamps
    end

    add_index :event_people, :event_id
    add_index :event_people, :person_id
  end
end
