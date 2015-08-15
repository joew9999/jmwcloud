class KbnAgain < ActiveRecord::Migration
  def change
    add_column :people, :primary_kbn, :string
    add_index :people, :primary_kbn
  end
end
