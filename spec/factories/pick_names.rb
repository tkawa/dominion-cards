# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pick_name do
    pick nil
    name "MyString"
    name_j "MyString"
    description "MyText"
  end
end
