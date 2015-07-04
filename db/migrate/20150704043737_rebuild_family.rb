class RebuildFamily < ActiveRecord::Migration
  def change
    drop_table :relationship_people

    add_column :people, :relationship_ids, :text, array: true, default: []
    add_column :people, :children_ids, :text, array: true, default: []
    add_column :relationships, :partner_ids, :text, array: true, default: []
    add_column :relationships, :children_ids, :text, array: true, default: []
  end
end
