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
	
	#SELECT CARDS - creates an array of numbered cards not yet 'in-play' for the game.
	it { Card.should respond_to(:select_cards) }

	describe "#select_cards" do
		let(:selected_cards) { Card.select_cards(new_game.id) }
		subject { selected_cards }

		context "the game has not yet started and the 1st card has NOT been played yet" do
			it "inclues only the numbered cards in the game's deck" do		
				subject.count.should == 52
			end
			
			it "includes only the 'not_in_play' cards in the game's deck" do
				subject.count.should == 52
			end
		end

		context "the game has already started and the 1st card has been played" do
			before(:each) do
				first_card = Card.where(game_id: new_game.id).first
				first_card.status = "card_in_play"
				first_card.save!
			end

			it "inclues only the numbered cards in the game's deck" do		
				subject.count.should == 51
			end
			
			it "includes only the 'not_in_play' cards in the game's deck" do
				subject.count.should == 51
			end
		end
	end

	#DEALER FLIPS A CARD - calls the "select cards" method and randomly
	#selects a card that will become the card-in-play. 
	it { Card.should respond_to(:dealer_flips_card) }

	describe "#dealer_flips_card" do
		before(:each) do
			@card =[]
			@card << FactoryGirl.create(:card)
		end

		it "calls 'select_cards' method " do
			expect(Card).to receive(:select_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_card(new_game.id)
		end
		
		it "calls 'select_cards' method and returns a value" do
			allow(Card).to receive(:select_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_card(new_game.id).should == "7"
		end

		it "assigns a status of 'card_in_play'" do
			allow(Card).to receive(:select_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_card(new_game.id)
			Card.find(@card.first.id).status.should == "card_in_play"
		end

		it "assigns an 'owner' of 'pot'" do
			allow(Card).to receive(:select_cards).with(new_game.id).and_return(@card)
			Card.dealer_flips_card(new_game.id)
			Card.find(@card.first.id).owner.should == "pot"
		end
	end

	#COUNT CARDS IN DECK - counts the numbers of cards remaining in the deck.
	it { Card.should respond_to(:count_cards_in_deck) }

	describe "#count_cards_in_deck" do

		it "totals the number of cards remaining in the deck" do
			Card.dealer_flips_card(new_game.id)
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

	# EVALUATE GUESS - evaluates the accuracy of the player's guess
		it { Card.should respond_to(:evaluate_guess) }

		describe "#evaluate_guess" do
		
			let(:guess_evaluation) { Card.evaluate_guess(new_game.id, guess, card_in_play, flipped_card) }
			let(:card_in_play) { "7"}
			let(:flipped_card) { "8" }
			let(:guess) { "higher"}
			
			subject { guess_evaluation }

			it "should call the evaluate_flipped_card method" do		
				expect(Card).to receive(:evaluate_flipped_card).with(card_in_play, flipped_card).and_return("higher")
				guess_evaluation			
			end

			context "#the flipped card is higher" do							
				before(:each) do
				 allow(Card).to receive(:evaluate_flipped_card).with(card_in_play, flipped_card).and_return("higher")			
				end
				context "the guess is 'higher'" do
					let(:guess) { "higher"}					
					it { should == "correct" }
				end
				
				context "the guess is 'lower'" do
					let(:guess) { "lower" }
					it { should == "wrong" }
				end		
			end

			context "#the flipped card is lower" do			
				before(:each) do
				 allow(Card).to receive(:evaluate_flipped_card).with(card_in_play, flipped_card).and_return("lower")			
				end
				
				context "the guess is 'lower'" do
					let(:guess) { "lower" }
					it { should == "correct" }
				end
				
				context "the guess is 'higher'" do
					let(:guess) { "higher"}
					it { should == "wrong" }
				end		
			end

			context "#the flipped card is the same" do			
				before(:each) do
				 allow(Card).to receive(:evaluate_flipped_card).with(card_in_play, flipped_card).and_return("same")			
				end
				
				context "the guess is 'lower'" do
					let(:guess) { "lower" }
					it { should == "same" }
				end
				
				context "the guess is 'higher'" do
					let(:guess) { "higher"}
					it { should == "same" }
				end		
			end

			context "#the flipped card is an action card" do			
				before(:each) do
				 allow(Card).to receive(:evaluate_flipped_card).with(card_in_play, flipped_card).and_return("action card")			
				end
				
				context "the guess is 'lower'" do
					let(:guess) { "lower" }
					it { should == "action card" }
				end
				
				context "the guess is 'higher'" do
					let(:guess) { "higher"}
					it { should == "action card" }
				end		
			end
		end	

	#### > end of EVALUATE GUESS


	# EVALUATE FLIPPED_CARD - determines whether the next card is higher or lower
	# than the card_in_play

	it { Card.should respond_to(:evaluate_flipped_card)}

	describe "#evaluate_flipped_card" do
		subject(:evaluate_flipped_card) { Card.evaluate_flipped_card(card_in_play, flipped_card) }

		context "flipped_card is larger than card_in_play" do
			let(:card_in_play) { "7"}
			let(:flipped_card) { "8"}	
			it { should == "higher" }
		end
		
		context "flipped_card is smaller than card_in_play" do
			let(:card_in_play) { "7"}
			let(:flipped_card) { "6"}	
			it { should == "lower" }
		end

		context "flipped_card is same as card_in_play" do
			let(:card_in_play) { "7"}
			let(:flipped_card) { "7"}	
			it { should == "same" }
		end
		
		context "flipped_card is same as card_in_play" do
			let(:card_in_play) { "7"}
			let(:flipped_card) { "7"}	
			it { should == "same" }
		end

		context "flipped_card is same as card_in_play" do
			let(:card_in_play) { "7"}
			let(:flipped_card) { "STRING"}	
			it { should == "action card" }
		end


	end


	# DETERMINE THE CARD IN PLAY FOR THE NEXT HAND - determines which card
	#will be the card in play for the next hand based on TuffCookies unique rules
	it { Card.should respond_to(:determine_the_card_in_play_for_next_hand)}

	describe "#determine the card in play for the next hand" do
		
		let(:determine_next_card) { Card.determine_the_card_in_play_for_next_hand(new_game.id, card_in_play, evaluation, flipped_card)}
		let(:card_in_play) { "7"}
		let(:flipped_card) { "8" }		
		subject { determine_next_card  }

		context "the players guess was correct" do
			let(:evaluation) { "correct"}		
			
			it "'card in play' equals the card that was just flipped" do
				expect(Card).to receive(:change_old_card_in_play_status).with(new_game.id, card_in_play).and_return(true)
				should == "8"
			end
		end
		
		context "the players guess was wrong" do
			let(:evaluation) { "wrong"}		
			
			it "'card in play' equals a newly flipped card" do
				expect(Card).to receive(:dealer_flips_card).with(new_game.id).and_return("11")
				expect(Card).to receive(:change_old_card_in_play_status).with(new_game.id, card_in_play).and_return(true)
				should == "11"
			end
		end

		
	end


	# CHANGE THE OLD CARD_IN_PLAY STATUS - resets the original card_in_play's status
	# so that the flipped card can become the new "card in play"

	it { Card.should respond_to(:change_old_card_in_play_status) }
	
	describe "#change_old_card_in_play_status" do	
		before(:each) do
			@old_card = Card.where(game_id: new_game.id).first
			@old_card.status = "card_in_play"
			@old_card.save!

		end 

		it "changes the old_card_in_plays status to 'played'" do
			Card.change_old_card_in_play_status(@old_card.game_id, @old_card.card_name)
			Card.find(@old_card.id).status.should == "played"
		end
	end


	# ZERO OUT THE POT - removes cards from the pot

	it { Card.should respond_to(:remove_cards_from_pot) }

	describe "#remove_cards_from_pot" do
		it "removes cards from the pot" do
			guess_evaluation = "wrong"
			game_id = new_game.id
			pot_card = Card.where(game_id: game_id).first
			pot_card.owner = "pot"
			pot_card.save!
			Card.remove_cards_from_pot(game_id, guess_evaluation)
			Card.where(game_id: game_id).where(owner: "pot").count.should == 0
	# 		# stopped_here:  for now, just assign the cards to the current player.

	 	end
	end

end
