# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    name "Seth"
    score 0
    player_order 1
    association :game
  end
end
