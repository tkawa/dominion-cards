class CreatePickNames < ActiveRecord::Migration
  def change
    create_table :pick_names do |t|
      t.belongs_to :pick, null: false
      t.string :name, null: false
      t.string :name_j
      t.string :canonical_name, null: false
      t.text :description
    end
    add_index :pick_names, :pick_id, unique: true
    add_index :pick_names, :name, unique: true
    add_index :pick_names, :name_j, unique: true
    add_index :pick_names, :canonical_name, unique: true
  end
end
