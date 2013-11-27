class Card < ActiveRecord::Base
  attr_accessible :card_name, :card_type, :game_id, :owner, :status
 	
 	belongs_to :game

 	def self.create_deck(game_id)
 		for i in 1..13
 			for each in 1..4
 				card = Card.new
 				card.card_name = i
 				card.card_type = "numbered"
 				card.status = "not_in_play"
 				card.owner = "dealer"
 				card.game_id = game_id
 				card.save!
 			end
 		end
 	end

 	def self.pull_numbered_cards(game_id)
		Card.where(game_id: game_id).where(card_type: "numbered").where(status: "not_in_play")
 	end

	def self.dealer_flips_numbered_card(game_id)
		numbered_cards = Card.pull_numbered_cards(game_id)
		flipped_card = numbered_cards.sample
		flipped_card.status = "card_in_play"
		flipped_card.owner = "pot"
		flipped_card.save!
		return flipped_card.card_name.to_i
	end

	def self.count_cards_in_deck(game_id)
		Card.where(game_id: game_id).where(status: "not_in_play").count
	end

	def self.show_cards_in_the_pot(game_id)
		pot = Card.where(game_id: game_id).where(owner: "pot")
		array ||= []
		pot.each { |card| array << card.card_name } 
		return array
	end

	# def self.evaluate_guess(game_id, guess, card_in_play)
	# 	#card_in_play = Card.where(game_id: game_id).where(status: "card_in_play").where(owner: "dealer").first
	# 	next_card = 8
	# 	if guess == "higher" && next_card > card_in_play.to_i 
	# 		"correct"
	# 	else
	# 		"wrong"
	# 	end
	# end

	# def self.pull_next_card(game_id)
	# 	cards = Card.where(game_id: game.id).where(status: "not_in_play")
	# 	next_card = cards.sample
	# 	next_card.status = "card_in_play"
	# 	next_card.owner = "pot"
	# 	next_card.save!
	# end

end
   