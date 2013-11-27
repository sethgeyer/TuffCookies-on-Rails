require 'spec_helper'

describe Card do
	
	let(:new_game) { FactoryGirl.create(:game)}
	
	before(:each) do
		Card.create_deck(new_game.id)
	end
	
	it { should belong_to(:game) }

	#CREATE DECK - creates a deck of cards for the related game
	it { Card.should respond_to(:create_deck)}

	describe "#create_deck" do
		it "should create a deck of 52 cards" do
			Card.where(game_id: new_game.id).all.count.should == 52
		end
	end
	
	#PULL NUMBERED CARDS - creates an array of numbered cards not yet 'in-play' for the game.
	it { Card.should respond_to(:pull_numbered_cards) }

	describe "#pull_numbered_cards" do
		let(:numbered_cards) { Card.pull_numbered_cards(new_game.id) }

		subject { numbered_cards }

		it "inclues only the numbered cards in the game's deck" do		
			subject.count.should == 52
		end
		
		it "includes only the 'not_in_play' cards in the game's deck" do
			subject.count.should == 52
		end
	end

	#DEALER FLIPS A NUMBERED CARD - calls the "pull numbered cards" method and randomly
	#selects a card that will become the card-in-play. 
	it { Card.should respond_to(:dealer_flips_numbered_card) }

	describe "#dealer_flips_numbered_card" do
		before(:each) do
			@card =[]
			@card << FactoryGirl.create(:card)
		end

		it "calls 'pull_numbered_cards' method " do
			expect(Card).to receive(:pull_numbered_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_numbered_card(new_game.id)
		end
		
		it "calls 'pull_numbered_cards' method and returns a value" do
			allow(Card).to receive(:pull_numbered_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_numbered_card(new_game.id).should == 7
		end

		it "assigns a status of 'card_in_play'" do
			allow(Card).to receive(:pull_numbered_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_numbered_card(new_game.id)
			Card.find(@card.first.id).status.should == "card_in_play"
		end

		it "assigns an 'owner' of 'pot'" do
			allow(Card).to receive(:pull_numbered_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_numbered_card(new_game.id)
			Card.find(@card.first.id).owner.should == "pot"
		end


	end

	#COUNT CARDS IN DECK - counts the numbers of cards remaining in the deck.
	it { Card.should respond_to(:count_cards_in_deck) }

	describe "#count_cards_in_deck" do
		it "totals the number of cards remaining in the deck" do
			Card.dealer_flips_numbered_card(new_game.id)
			Card.count_cards_in_deck(new_game.id).should == 51

		end
	end

	#SHOW CARDS IN POT - shows cards currently in the pot.
	it { Card.should respond_to(:show_cards_in_the_pot) }	

	describe "#show_cards_in_the_pot" do
		before(:each) do
			FactoryGirl.create(:card, card_name: "1", owner: "pot", game_id: new_game.id)
			FactoryGirl.create(:card, card_name: "2", owner: "pot", game_id: new_game.id)
		end

		it "shows cards in the pot" do
			Card.show_cards_in_the_pot(new_game.id).should == ["1", "2"]
		end
	end

	# #EVALUATE GUESS - evaluates the accuracy of the player's guess
	# it { Card.should respond_to(:evaluate_guess) }

	# describe "#evaluate_guess" do
	# 	context "next card is higher" do
	# 		it "returns correct if the guess is higher" do
	# 			Card.evaluate_guess(new_game.id, 'higher', "7").should == "correct"
	# 		end
	# 		it "returns wrong if the guess is lower" do
	# 			Card.evaluate_guess(new_game.id, 'lower', "7").should == "wrong"
	# 		end
	# 	end
	# end	

	# #PULL NEXT CARD - pulls the next card from the stack
	# it { Card.should respond_to(:pull_next_card) }

	# describe "#pull_next_card" do
	# 	it "returns an not_in_play card from the deck" do
	# 		Card.pull_next_card(new_game.id).should == 4
	# 	end
	# end

end
