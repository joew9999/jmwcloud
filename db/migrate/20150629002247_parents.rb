class Parents < ActiveRecord::Migration
  def change
    add_column :relationship_people, :type, :string
    add_index :relationship_people, :type
  end
end
