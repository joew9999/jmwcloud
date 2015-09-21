class RemoveEvents < ActiveRecord::Migration
  def change
    remove_column :people, :birth_date
    remove_column :people, :birth_place_id
    remove_column :people, :death_date
    remove_column :people, :death_place_id

    drop_table :event_people
    drop_table :relationship_events
    drop_table :events

    add_column :people, :birth_day, :string
    add_column :people, :birth_place, :string
    add_column :people, :death_day, :string
    add_column :people, :death_place, :string

    add_column :relationships, :marriage_day, :string
    add_column :relationships, :divorce_day, :string
#added 9/16
    # add_column :relationships, :s_suffix, :string
    # add_column :relationships, :death_mark, :string
    # add_column :relationships, :other_names, :string
  end
end
