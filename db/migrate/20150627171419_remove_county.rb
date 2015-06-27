class RemoveCounty < ActiveRecord::Migration
  def change
    remove_column :events, :county
  end
end
