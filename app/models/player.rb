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

  def self.determine_the_next_player(game_id, current_player_number, guess_evaluation)
    
    direction_of_play = Game.find(game_id).direction

    ascending = { 1=>2, 2=>3, 3=>4, 4=>1}
    descending = { 1=>4, 2=>1, 3=>2, 4=>3}

    if guess_evaluation == "correct"
      Player.where(game_id: game_id).where(number: current_player_number.to_i).first.name
    elsif direction_of_play == "ascending"
      Player.where(game_id: game_id).where(number: ascending[current_player_number.to_i]).first.name
    elsif direction_of_play == "descending"
      Player.where(game_id: game_id).where(number: descending[current_player_number.to_i]).first.name      
    end
  end

  def self.select_awardee(game_id, current_player_number, guess_evaluation)
    
    direction_of_play = Game.find(game_id).direction    

    descending = { 1=>2, 2=>3, 3=>4, 4=>1}
    ascending = { 1=>4, 2=>1, 3=>2, 4=>3}

    if guess_evaluation == "wrong"
      if direction_of_play == "ascending" 
        Player.where(game_id: game_id).where(number: ascending[current_player_number.to_i]).first.name
      elsif direction_of_play == "descending"
        Player.where(game_id: game_id).where(number: descending[current_player_number.to_i]).first.name
      end
    else
      "ERROR ON SELECT AWARDEE"
    end

  end





end
