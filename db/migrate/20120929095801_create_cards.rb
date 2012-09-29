class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name_j, null: false
      t.text :description
      t.string :kana, null: false
      t.string :name, null: false
      t.string :set, null: false
      t.integer :cost
      t.integer :potion
      t.string :division, null: false
      t.string :kind, null: false
      t.integer :treasure
      t.integer :victory
      t.integer :cards
      t.integer :actions
      t.integer :buys
      t.integer :coins
      t.integer :vp_tokens
    end
    add_index :cards, :name_j, unique: true
    add_index :cards, :name, unique: true
  end
end
