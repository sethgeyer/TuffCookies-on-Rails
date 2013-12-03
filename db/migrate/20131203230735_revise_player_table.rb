class RevisePlayerTable < ActiveRecord::Migration
  def up
  	remove_column :players, :score
  end

  def down
  	add_column :players, :score, :integer
  end
end
