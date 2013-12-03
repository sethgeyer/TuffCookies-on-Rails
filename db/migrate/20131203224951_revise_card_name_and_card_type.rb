class ReviseCardNameAndCardType < ActiveRecord::Migration
  def up
  	rename_column :cards, :card_name, :name
  end

  def down
  	rename_column :cards, :name, :card_name
  end
end
