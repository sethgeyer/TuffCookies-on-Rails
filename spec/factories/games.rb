# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
  	consecutive_correct_guesses 0
  	direction "ascending"
  
  end
end
