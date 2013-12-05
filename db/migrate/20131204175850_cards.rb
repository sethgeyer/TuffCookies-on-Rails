class Cards < ActiveRecord::Migration
  def up
  	add_column :cards, :order, :integer
  end

  def down
  	remove_column :cards, :order
  end
end
