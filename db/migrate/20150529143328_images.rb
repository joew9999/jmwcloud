class Images < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :type

      t.timestamp
    end

    add_index :images, :type
    add_attachment :images, :image
  end
end
