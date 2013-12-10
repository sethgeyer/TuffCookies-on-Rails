class AddSomeColumnsToGame < ActiveRecord::Migration
  def up
  	add_column :games, :consecutive_correct_guesses, :integer
  	add_column :games, :direction, :string
  end

  def down
  	remove_column :cards, :consecutive_correct_guesses	
  	remove_column :cards, :direction
  end
end
