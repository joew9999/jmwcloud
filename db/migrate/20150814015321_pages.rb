class Pages < ActiveRecord::Migration
  def change
    add_column :people, :pages, :string, array: true, default: []
    add_column :people, :other_names, :string, array: true, default: []
    add_index :people, :other_names
  end
end
