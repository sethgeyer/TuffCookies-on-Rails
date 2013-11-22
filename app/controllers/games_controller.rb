class GamesController < ApplicationController

	# def welcome
	# 	render :welcome
	# end

	# def rules
	# 	render :rules
	# end

	def game_on
		
		redirect_to game_board_path
	end

	def game_board
		render(:game_board)
	end

end

