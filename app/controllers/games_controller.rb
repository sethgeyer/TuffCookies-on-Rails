class GamesController < ApplicationController


	def lets_play #(Post from welcome page)
		game = Game.new
		game.consecutive_correct_guesses = 0
		game.direction = "ascending"
		game.save!
		Player.create_players(params[:player_name], game)
		Card.create_deck(game.id)
		Card.dealer_flips_card(game.id)		
		evaluation = "none"
		redirect_to "/game_on/#{game.id}/#{evaluation}"

	end

	def game_on
		game_id = params[:game_id]
		game_cards = Card.where(game_id: game_id)
		@players_in_order = Player.where(game_id: game_id).order(:number)
		@player = @players_in_order.where(current_player: 1).first || @players_in_order.first
		@card_in_play = game_cards.where(status: "card_in_play").first.name
		@cards_remaining_in_deck = game_cards.where(status: "not_in_play").count
		@cards_in_the_pot = Card.show_cards_in_the_pot(game_id)
		@evaluation = params[:evaluation]
		@consecutive_correct_guesses = Game.find(game_id).consecutive_correct_guesses
		#####showing cards in deck for feature testing purposes only
		deck_array = []
		game_cards.where(status: "not_in_play").order(:card_order).limit(10).each { |card| deck_array << card.name } 
		@deck_array = deck_array
		#####

		render(:game_on)
	end

	def player_guess #(Post from game_on page)
		game_id = params[:game_id]
		current_player_number = params[:number]
		if params[:sweep]
			redirect_to "/route_2_page" 
		else
			guess = params[:higher] || params[:lower]
			card_in_play = Card.where(game_id: game_id).where(status: "card_in_play").first.name
			flipped_card = Card.dealer_flips_card(game_id)
			guess_evaluation = Card.evaluate_guess(game_id, guess, card_in_play, flipped_card)
			Game.track_consecutive_correct_guesses(game_id, guess_evaluation)
			#Card.award_cards_in_the_pot(game_id, current_player_number, guess_evaluation)
			Card.determine_the_card_in_play_for_next_hand(game_id, guess_evaluation, card_in_play, flipped_card)
			redirect_to "/game_on/#{game_id}/#{guess_evaluation}"
		end
	end


	def route_1
		render :route_1_page
	end

	def route_2
		render :route_2_page
	end

end

