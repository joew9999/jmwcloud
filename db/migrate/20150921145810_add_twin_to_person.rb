class AddTwinToPerson < ActiveRecord::Migration
  def change
    add_column :people, :twin, :string 
  end
end
