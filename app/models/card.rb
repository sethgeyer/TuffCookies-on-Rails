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

 	def self.select_cards(game_id)
		total_cards = Card.where(game_id: game_id).where(status: "not_in_play")
		
		if total_cards.count == 52
			total_cards.where(card_type: "numbered")
 		else
 			total_cards
 		end


 	end

	def self.dealer_flips_card(game_id)
		total_cards = Card.select_cards(game_id)
		flipped_card = total_cards.sample
		flipped_card.status = "card_in_play"
		flipped_card.owner = "pot"
		flipped_card.save!
		return flipped_card.card_name
	end

	def self.count_cards_in_deck(game_id)
		Card.where(game_id: game_id).where(status: "not_in_play").count
	end

	def self.show_cards_in_the_pot(game_id)
		pot = Card.where(game_id: game_id).where(owner: "pot")
		array = []
		pot.each { |card| array << card.card_name } 
		return array
	end

	def self.evaluate_guess(game_id, guess, card_in_play, flipped_card)
		if guess == "higher" 
			if flipped_card.to_i > card_in_play.to_i 
				"correct"
			else
				"wrong"
			end
		elsif guess == "lower"
			if flipped_card.to_i < card_in_play.to_i 
				"correct"
			else
				"wrong"
			end
		else
			"EVALUATE GUESS ERROR-NEED TO FIX BUG"
		end
	end

	def self.determine_the_card_in_play_for_next_hand(game_id, card_in_play, evaluation, flipped_card)
		Card.change_old_card_in_play_status(game_id, card_in_play)
		if evaluation == "correct"
			return flipped_card
		elsif evaluation == "wrong"
			Card.dealer_flips_card(game_id)
		else
		end

	end

	def self.change_old_card_in_play_status(game_id, card_in_play)
			old_card_in_play = Card.where(game_id: game_id).where(status: "card_in_play").where(card_name: card_in_play).first
			old_card_in_play.status = "played"
			old_card_in_play.save!		
	end

	def self.award_cards_in_pot
		5
	end



end
   