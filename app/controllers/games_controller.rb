class GamesController < ApplicationController


	def lets_play
		game = Game.new
		game.save!
		Player.create_player(params[:player_name], game)
		Card.create_deck(game)		
		redirect_to game_on_path

	end

	def game_on
		@player = Player.last	
		#need to specify that it should only be the cards associated w the particular game
		@cards_remaining_in_deck = Card.all.count	
		render(:game_on)
	end

end

