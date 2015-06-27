class Kbn < ActiveRecord::Migration
  def change
    create_table :book_numbers do |t|
      t.string :kbn

      t.timestamps
    end

    add_index :book_numbers, :kbn

    create_table :people_book_numbers do |t|
      t.integer :book_number_id
      t.integer :person_id

      t.timestamps
    end

    add_index :people_book_numbers, :book_number_id
    add_index :people_book_numbers, :person_id
  end
end
