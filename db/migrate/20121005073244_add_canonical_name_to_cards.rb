class AddCanonicalNameToCards < ActiveRecord::Migration
  def change
    change_table :cards do |t|
      t.string :canonical_name
    end
    add_index :cards, :canonical_name, unique: true
    Card.find_each do |card|
      card.canonical_name = card.name.tr("'", "").parameterize
      card.save!
    end
    change_column :cards, :canonical_name, :string, null: false
  end
end
