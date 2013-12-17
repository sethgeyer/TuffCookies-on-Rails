class Card < ActiveRecord::Base
  attr_accessible :name, :card_type, :game_id, :owner, :status, :card_order
 	
 	belongs_to :game

 	@DECK_SIZE = 54

 	def self.create_deck(game_id)
 		array = []
 		for i in 1..@DECK_SIZE
 			array << i
 		end
 		array.shuffle!

 		for i in 1..13
 			for each in 1..4
 				card = Card.new
 				card.name = i
 				card.card_type = "numbered"
 				card.status = "not_in_play"
 				card.owner = "dealer"
 				card.card_order = array.shift
 				card.game_id = game_id
 				card.save!
 			end
 		end

 		for i in 1..2
			card = Card.new
			card.name = "Reverse"
			card.card_type = "action_card"
			card.status = "not_in_play"
			card.owner = "dealer"
			card.card_order = array.shift
			card.game_id = game_id
			card.save!
 		end

 	end

 	def self.select_cards(game_id)
		shuffled_deck = Card.where(game_id: game_id).where(status: "not_in_play").order(:card_order)
		if shuffled_deck.count == @DECK_SIZE
			shuffled_deck.where(card_type: "numbered")
 		else
 			shuffled_deck
 		end
 	end

	def self.dealer_flips_card(game_id)
		
		shuffled_deck = Card.select_cards(game_id)	
		@flipped_card = shuffled_deck.first
		
		if @flipped_card.card_type != "action_card"
			@flipped_card.status = "card_in_play"
			Card.change_old_card_in_play_status(game_id)
		else
			@flipped_card.status = "played"
		end

		@flipped_card.owner = "pot"
		@flipped_card.save!
		# if flipped_card.card_type == "action_card"
		# 	Card.dealer_flips_card(game_id) 
		# end

		while @flipped_card.card_type == "action_card" do
			Card.dealer_flips_card(game_id)
		end
			
		return @flipped_card.name
	end

	def self.change_old_card_in_play_status(game_id)
		old_card_in_play = Card.where(game_id: game_id).where(status: "card_in_play").first
		unless old_card_in_play == nil
			old_card_in_play.status = "played"			
			old_card_in_play.save!
		end
	end



	def self.show_cards_in_the_pot(game_id)
		pot = Card.where(game_id: game_id).where(owner: "pot").order("card_order desc")
		array = []
		pot.each { |card| array << card.name } 
		return array
	end

	def self.evaluate_guess(game_id, guess, card_in_play, flipped_card)
		flipped_card_evaluation = Card.evaluate_flipped_card(card_in_play, flipped_card)
		if flipped_card_evaluation == guess 
			"correct"
		elsif flipped_card_evaluation == "same" 
			"same"
		elsif flipped_card_evaluation == "action_card"
			#take action on actioncard(flipped_card)
			game = Game.find(game_id)
			game.direction = if game.direction == "descending"
				"ascending" 
			else 
				"descending"
			end		
			game.save!
			return "action_card"				
		else
			"wrong"
		end
	end

	# def self.take_action_on_action_card 
		# if reverse 
			#change game direction"

	#end


	def self.evaluate_flipped_card(card_in_play, flipped_card)
		difference = flipped_card.to_i - card_in_play.to_i
		if flipped_card.to_i == 0  # is an action_card
			"action_card"
		elsif difference > 0
			"higher"
		elsif difference < 0
			"lower"
		elsif difference == 0
			"same"
		else
			"EVALUATE FLIPPED CARD ERROR"
		end
	end

	def self.determine_the_card_in_play_for_next_hand(game_id,  guess_evaluation, card_in_play, flipped_card)
		if guess_evaluation == "correct" || guess_evaluation == "same"
			flipped_card
		elsif guess_evaluation == "action_card"
			card_in_play
		else #your guess is "wrong"
			Card.dealer_flips_card(game_id)
		end

	end


	def self.award_cards_in_the_pot(game_id, current_player_number, guess_evaluation_or_sweep)
		awardee = Player.select_awardee(game_id, current_player_number, guess_evaluation_or_sweep)
		if guess_evaluation_or_sweep == "wrong" || guess_evaluation_or_sweep == "sweep"
	 		pot_cards = Card.where(game_id: game_id).where(owner: "pot")
	 		pot_cards.each do |card|
	 		card.owner = awardee
	 		card.save!
	 	end
	 end
	end





end
   