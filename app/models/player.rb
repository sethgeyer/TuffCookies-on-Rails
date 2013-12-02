class Player < ActiveRecord::Base
  attr_accessible :game_id, :name, :player_order, :score

  belongs_to :game

  def self.create_players(player_name, game)
  	players = [player_name, "Noah", "George", "Anne"]
  	players.each do |player|
  		virtual_player = Player.new
  		virtual_player.name = player
  		virtual_player.score = 0
  		virtual_player.player_order = players.index(player) + 1
  		virtual_player.game_id = game.id
  		virtual_player.save!
  	end
  end

  def self.select_awardee(game_id, current_player_number, guess_evaluation)
    if guess_evaluation == "wrong"
      Player.where(game_id: game_id).where(player_order: 2).first.name
    else
      "ERROR ON SELECT AWARDEE"
    end
  end





end
