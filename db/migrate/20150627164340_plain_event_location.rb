class PlainEventLocation < ActiveRecord::Migration
  def change
    remove_column :events, :city
    remove_column :events, :state
    remove_column :events, :country
    add_column :events, :location, :string
    add_index :events, :location
  end
end
