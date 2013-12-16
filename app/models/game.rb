class Game < ActiveRecord::Base
  
	attr_accessible :consecutive_correct_guesses, :direction, :last_correct_guesser


	has_many :cards
	has_many :players

	def self.track_consecutive_correct_guesses(game_id, guess_evaluation, current_player_number)
		game = Game.find(game_id)
		if guess_evaluation == "correct"
			game.consecutive_correct_guesses += 1
			game.last_correct_guesser = current_player_number
		elsif guess_evaluation == "wrong" || guess_evaluation == "sweep"
			game.consecutive_correct_guesses = 0
		else
		end
		game.save!
	end
  
  
end



