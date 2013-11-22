class Card < ActiveRecord::Base
  attr_accessible :card_name, :card_type, :game_id, :owner, :status
 	belongs_to :game

 	def self.create_deck(game)
 		for i in 1..13
 			for each in 1..4
 				card = Card.new
 				card.card_name = "#{i}"
 				card.card_type = "numbered"
 				card.status = "not_in_play"
 				card.owner = "dealer"
 				card.game_id = game.id
 				card.save!
 			end
 		end
 	end

end
