# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    name_j "MyString"
    description "MyText"
    kana "MyString"
    name "MyString"
    set "MyString"
    cost 1
    potion 1
    division "MyString"
    kind "MyString"
    treasure 1
    victory 1
    cards 1
    actions 1
    buys 1
    coins 1
    vp_tokens 1
  end
end
