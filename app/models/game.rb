class Game < ActiveRecord::Base
  
	attr_accessible :consecutive_correct_guesses, :direction


	has_many :cards
	has_many :players

	def self.track_consecutive_correct_guesses(game_id, guess_evaluation)
		game = Game.find(game_id)
		if guess_evaluation == "correct"
			game.consecutive_correct_guesses += 1
		elsif guess_evaluation == "wrong" || guess_evaluation == "sweep"
			game.consecutive_correct_guesses = 0
		else
		end
		game.save!
	end
  
  
end



