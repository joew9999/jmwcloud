
class Arrays < ActiveRecord::Migration
  def change
    remove_column :people, :last_name
    remove_column :people, :kbn

    add_column :people, :last_names, :string, array: true, default: []
    add_column :people, :kbns, :string, array: true, default: []
    add_column :people, :first_generation, :string, array: true, default: []
    add_column :people, :second_generation, :string, array: true, default: []
    add_column :people, :third_generation, :string, array: true, default: []
    add_column :people, :fourth_generation, :string, array: true, default: []
    add_column :people, :fifth_generation, :string, array: true, default: []
    add_column :people, :sixth_generation, :string, array: true, default: []
    add_column :people, :seventh_generation, :string, array: true, default: []
    add_column :people, :eighth_generation, :string, array: true, default: []
    add_column :people, :ninth_generation, :string, array:true, default: []
    add_index :people, :last_names
    add_index :people, :kbns
    add_index :people, :first_generation
    add_index :people, :second_generation
    add_index :people, :third_generation
    add_index :people, :fourth_generation
    add_index :people, :fifth_generation
    add_index :people, :sixth_generation
    add_index :people, :seventh_generation
    add_index :people, :eighth_generation
    add_index :people, :ninth_generation
  end
end
