# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    name "7"
    card_type "numbered"
    status "not_in_play"
    owner "dealer"
    card_order 1
    association :game
  end

end
