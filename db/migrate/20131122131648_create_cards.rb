class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_name
      t.string :card_type
      t.string :status
      t.string :owner
      t.integer :game_id

      t.timestamps
    end
  end
end
