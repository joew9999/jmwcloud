class RemoveBookNumbers < ActiveRecord::Migration
  def change
    drop_table :book_numbers
    drop_table :people_book_numbers

    add_column :people, :kbn, :string
    add_index :people, :kbn
  end
end
