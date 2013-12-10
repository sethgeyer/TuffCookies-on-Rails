class Player < ActiveRecord::Base
  attr_accessible :game_id, :name, :number, :current_player, :direction

  belongs_to :game

  def self.create_players(human_player_name, game)
  	players = [human_player_name, "Noah", "George", "Anne"]
  	players.each do |player_name|
  		player = Player.new
  		player.name = player_name
  		player.number = players.index(player_name) + 1
  		player.game_id = game.id
  		player.save!
  	end
  end

  def self.determine_the_next_player(game_id, guess_evaluation)
    if guess_evaluation == "wrong"
      direction_of_play = Game.find(game_id).direction
      current_player = Player.where(game_id: game_id).where(current_player: 1).first || Player.where(game_id: game_id).first
      current_player.current_player = 0
      current_player.save!
      
      if direction_of_play = "ascending"
        next_player = Player.where(game_id: game_id).where(number: current_player.number + 1).first
        next_player.current_player = 1
        next_player.save!
      else
        next_player = Player.where(game_id: game_id).where(number: 3).first
        next_player.current_player = 1
        next_player.save!
      end

    end
  end



  def self.select_awardee(game_id, current_player_number, guess_evaluation)
    if guess_evaluation == "wrong"
      Player.where(game_id: game_id).where(number: 2).first.name
    else
      "ERROR ON SELECT AWARDEE"
    end
  end





end
