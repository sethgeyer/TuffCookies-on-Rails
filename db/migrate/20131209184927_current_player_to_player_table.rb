class CurrentPlayerToPlayerTable < ActiveRecord::Migration
  def up
  	add_column :players, :current_player, :integer
  end

  def down
  	remove_column :players, :current_player
  end
end
