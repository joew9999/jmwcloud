class Adoption < ActiveRecord::Migration
  def change
    add_column :people, :adopted_day, :string
    add_column :people, :adoption_text, :string
    add_column :people, :adoption_type, :string
  end
end
