class Relationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.timestamps
    end

    create_table :relationship_people do |t|
      t.integer :relationship_id
      t.integer :person_id
      t.integer :order

      t.timestamps
    end

    add_index :relationship_people, :relationship_id
    add_index :relationship_people, :person_id
    add_index :relationship_people, :order

    create_table :relationship_events do |t|
      t.integer :relationship_id
      t.integer :event_id
      t.integer :order

      t.timestamps
    end

    add_index :relationship_events, :relationship_id
    add_index :relationship_events, :event_id
    add_index :relationship_events, :order
  end
end
