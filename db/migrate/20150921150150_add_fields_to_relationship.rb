class AddFieldsToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :s_suffix, :string
    add_column :relationships, :death_mark, :string
    add_column :relationships, :other_name, :string
  end
end
