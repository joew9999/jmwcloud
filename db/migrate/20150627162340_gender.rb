class Gender < ActiveRecord::Migration
  def change
    add_column :people, :male, :boolean, default: false
    add_column :people, :suffix, :string

    add_index :people, :male
  end
end
