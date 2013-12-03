class RevisePlayerOrder < ActiveRecord::Migration
  def up
  rename_column :players, :player_order, :number
  end

  def down
  	rename_column :players, :number, :player_order
  end
end
