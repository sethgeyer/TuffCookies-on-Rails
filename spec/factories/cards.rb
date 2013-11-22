# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    card_name "MyString"
    card_type ""
    status ""
    owner ""
    association :game
  end
end
