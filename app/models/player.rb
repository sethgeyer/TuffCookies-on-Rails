class Player < ActiveRecord::Base
  attr_accessible :game_id, :name, :number

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

  def self.select_awardee(game_id, current_player_number, guess_evaluation)
    if guess_evaluation == "wrong"
      Player.where(game_id: game_id).where(number: 2).first.name
    else
      "ERROR ON SELECT AWARDEE"
    end
  end





end
