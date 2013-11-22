class Player < ActiveRecord::Base
  attr_accessible :game_id, :name, :player_order, :score

  belongs_to :game

  def self.create_player(player_name, game)
  	player = Player.new
  	player.name = player_name
  	player.score = 0
  	player.game_id = game.id
  	player.save!
  end
end
