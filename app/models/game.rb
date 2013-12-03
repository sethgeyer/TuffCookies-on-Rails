class Game < ActiveRecord::Base
  
	has_many :cards
	has_many :players

  # def create_deck
  # 	for i in 1..13
  # 		for a in 1..4
	 #  		card = Card.new
	 #  		card.name = "#{i}"
	 #  		card.card_type = "numbered"
	 #  		card.game_id = 1
	 #  		card.owner = "dealer"
	 #  		card.status = "not_in_play"
	 #  		card.save!
  # 		end
  # 	end
  # end
  
  
end



