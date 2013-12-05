class ReviseOrderNameInCards < ActiveRecord::Migration
 
  def up
  	rename_column :cards, :order, :card_order
  end

  def down
  	rename_column :cards, :card_order, :order
  end

end
