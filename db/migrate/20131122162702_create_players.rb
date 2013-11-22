class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :score
      t.integer :player_order
      t.integer :game_id

      t.timestamps
    end
  end
end
