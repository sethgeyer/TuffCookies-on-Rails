# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    sequence(:name) { |i| "Playa#{i}" }
    number 1
    #current_player 1
    association :game
  end
end
