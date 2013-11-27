# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    sequence(:name) { |i| "Playa#{i}" }
    score 0
    player_order 1
    association :game
  end
end
