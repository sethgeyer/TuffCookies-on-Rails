class GamesController < ApplicationController


	def lets_play #(Post from welcome page)
		game = Game.new
		game.save!
		Player.create_players(params[:player_name], game)
		Card.create_deck(game.id)
		Card.dealer_flips_card(game.id)		
		redirect_to "/game_on/#{game.id}"

	end

	def game_on
		@player = Player.where(game_id: params[:game_id]).first	
		@players_in_order = Player.where(game_id: params[:game_id]).order(:player_order)
		@card_in_play = Card.where(game_id: params[:game_id]).where(status: "card_in_play").first.card_name
		@cards_remaining_in_deck = Card.count_cards_in_deck(params[:game_id])
		@cards_in_the_pot = Card.show_cards_in_the_pot(params[:game_id])
		render(:game_on)
	end

	def player_guess #(Post from game_on page)
		game_id = params[:game_id]
		if params[:sweep]
			redirect_to "/route_2_page" 
		else
			guess = params[:higher] || params[:lower]
			flipped_card = Card.dealer_flips_card(game_id)
			card_in_play = Card.where(game_id: game_id).where(status: "card_in_play").first.card_name
			evaluation = Card.evaluate_guess(game_id, guess, card_in_play, flipped_card)
			Card.determine_the_card_in_play_for_next_hand(game_id, card_in_play, evaluation, flipped_card)
			redirect_to "/game_on/#{game_id}"
		end
	end


	def route_1
		render :route_1_page
	end

	def route_2
		render :route_2_page
	end

end

