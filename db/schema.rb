# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121005073244) do

  create_table "cards", :force => true do |t|
    t.string  "name_j",         :null => false
    t.text    "description"
    t.string  "kana",           :null => false
    t.string  "name",           :null => false
    t.string  "set",            :null => false
    t.integer "cost"
    t.integer "potion"
    t.string  "division",       :null => false
    t.string  "kind",           :null => false
    t.integer "treasure"
    t.integer "victory"
    t.integer "cards"
    t.integer "actions"
    t.integer "buys"
    t.integer "coins"
    t.integer "vp_tokens"
    t.string  "canonical_name", :null => false
  end

  add_index "cards", ["canonical_name"], :name => "index_cards_on_canonical_name", :unique => true
  add_index "cards", ["name"], :name => "index_cards_on_name", :unique => true
  add_index "cards", ["name_j"], :name => "index_cards_on_name_j", :unique => true

end
