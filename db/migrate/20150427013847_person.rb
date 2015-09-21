class Person < ActiveRecord::Migration
  def change
    add_column :users, :person_id, :integer
    add_index :users, :person_id

    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :birth_date
      t.integer :birth_place_id
      t.datetime :death_date
      t.integer :death_place_id


      t.timestamps
    end

    add_index :people, :first_name
    add_index :people, :last_name

    create_table :events do |e|
      e.string :type
      e.integer :person_id
      e.datetime :time
      e.string :city
      e.string :county
      e.string :state
      e.string :country

      e.timestamps
    end

    add_index :events, :time
    add_index :events, :city
    add_index :events, :county
    add_index :events, :state
    add_index :events, :country
  end
end
