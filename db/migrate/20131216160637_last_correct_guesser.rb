class LastCorrectGuesser < ActiveRecord::Migration
  def up
  add_column :games, :last_correct_guesser, :integer
  end

  def down
  	remove_column :games, :last_correct_guesser
  end
end
