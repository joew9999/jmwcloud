class RemoveGenerationIndex < ActiveRecord::Migration
  def change
    remove_index :people, :first_generation
    remove_index :people, :second_generation
    remove_index :people, :third_generation
    remove_index :people, :fourth_generation
    remove_index :people, :fifth_generation
    remove_index :people, :sixth_generation
    remove_index :people, :seventh_generation
    remove_index :people, :eighth_generation
    remove_index :people, :ninth_generation
  end
end
