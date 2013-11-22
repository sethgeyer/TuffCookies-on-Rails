require 'spec_helper'

describe Game do

	# Testing Associations
	it { should have_many(:cards) }
	it { should have_many(:players) }



	# it "creates a new deck of 52 cards for the game" do
	# 	game = Game.new
	# 	game.create_deck
	# 	game.cards.count.should == 52
	# end

#   pending "add some examples to (or delete) #{__FILE__}"
end
