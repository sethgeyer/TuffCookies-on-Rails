require 'spec_helper'

describe Card do
	let(:new_game) { FactoryGirl.create(:game)}
	
	before(:each) do
		Card.create_deck(new_game.id)
	end
	
	it { should belong_to(:game) }

	#CREATE DECK - creates a deck of cards for the new game
	it { Card.should respond_to(:create_deck) }

	describe "#create_deck" do
		it "should create a deck of 52 numbered cards" do
			Card.where(game_id: new_game.id).where(card_type: "numbered").all.count.should == 52
		end

		it "should create 2 'reverse cards'" do
			Card.where(game_id: new_game.id).where(card_type: "action_card").where(name: "Reverse").all.count.should == 2
		end
		
		it "should 'virtually shuffle' the cards by assigning a random 'order' to the cards" do
			# how do I test for the random assignment of an order number
			count = 0
			cards = Card.where(game_id: new_game.id)
			cards.each { | card | count += card.card_order }
			count.should == 1485
		end
	end
	
	#SELECT CARDS - creates an array of that may be flipped by the dealer.
	it { Card.should respond_to(:select_cards) }

	describe "#select_cards" do
		subject(:selected_cards) { Card.select_cards(new_game.id) }

		context "the game has not yet started and the 1st card has NOT been played yet" do
			it "inclues only the numbered cards in the game's deck" do		
				subject.count.should == 52
			end
		end

		context "the game has already started and the 1st card has been played" do
			before(:each) do
				first_card = Card.where(game_id: new_game.id).first
				first_card.status = "card_in_play"
				first_card.save!
			end

			it "inclues all 'not_in_play' cards in the game's deck" do		
				subject.count.should == Card.where(game_id: new_game.id).count - 1
			end
		end
	end

	#DEALER FLIPS A CARD - calls the "select cards" method and randomly
	#selects a card that will become the card-in-play. 
	it { Card.should respond_to(:dealer_flips_card) }

	describe "#dealer_flips_card" do
		
		before(:each) do
			@cards = Card.where(game_id: new_game.id).where(status: "not_in_play").order(:card_order)
			allow(Card).to receive(:select_cards).with(new_game.id).and_return(@cards)
			allow(Card).to receive(:change_old_card_in_play_status).with(new_game.id).and_return(true)
		end

		it "calls 'select_cards' method " do
			expect(Card).to receive(:select_cards).with(new_game.id).and_return(@cards)
			Card.dealer_flips_card(new_game.id)
		end
		
		it "calls the 'change_old_card_in_play_status' method" do
			expect(Card).to receive(:change_old_card_in_play_status).with(new_game.id).and_return(true)
			Card.dealer_flips_card(new_game.id)
		end

		it "returns the name of the flipped card" do
			Card.dealer_flips_card(new_game.id).should == @cards.first.name
		end

		it "assigns a status of 'card_in_play' to the flipped card" do
			Card.dealer_flips_card(new_game.id)
			Card.find(@cards.first.id).status.should == "card_in_play"
		end

		it "assigns an 'owner' of 'pot' to the flipped_card" do
			Card.dealer_flips_card(new_game.id)
			Card.find(@cards.first.id).owner.should == "pot"
		end
	end


	#SHOW CARDS IN POT - shows cards currently in the pot.
	it { Card.should respond_to(:show_cards_in_the_pot) }	

	describe "#show_cards_in_the_pot" do
		before(:each) do
			FactoryGirl.create(:card, name: "7", card_order: 1, owner: "pot", game_id: new_game.id)
			FactoryGirl.create(:card, name: "8", card_order: 2, owner: "pot", game_id: new_game.id)
		end

		it "shows cards in the pot" do
			Card.show_cards_in_the_pot(new_game.id).should == ["8", "7"]
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

			context "the flipped card is higher" do							
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

			context "the flipped card is lower" do			
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

			context "the flipped card is the same" do			
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

			context "the flipped card is an action card" do			
				before(:each) do
				 allow(Card).to receive(:evaluate_flipped_card).with(card_in_play, flipped_card).and_return("action_card")			
				end
				
				context "the guess is 'lower'" do
					let(:guess) { "lower" }
					it { should == "action_card" }
				end
				
				context "the guess is 'higher'" do
					let(:guess) { "higher"}
					it { should == "action_card" }
				end

				context "the action card ia a 'Reverse' card" do
					let(:guess) { "lower" }
					let(:flipped_card) { "Reverse" }
					it "should reverse the order of play" do
						guess_evaluation
						Game.find(new_game.id).direction.should == "descending"
					end
				end

				context "the action card ia a 'Reverse' card" do
					let(:guess) { "lower" }
					let(:flipped_card) { "Reverse" }
					before(:each) do
						game = Game.find(new_game.id)
						game.direction = "descending"
						game.save!
					end

					it "should reverse the order of play" do
						guess_evaluation
						Game.find(new_game.id).direction.should == "ascending"
					end
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
			it { should == "action_card" }
		end

	end


	# DETERMINE THE CARD IN PLAY FOR THE NEXT HAND - determines which card
	#will be the card in play for the next hand based on TuffCookies unique rules
	it { Card.should respond_to(:determine_the_card_in_play_for_next_hand)}

	describe "#determine the card in play for the next hand" do
		
		let(:determine_next_card) { Card.determine_the_card_in_play_for_next_hand(new_game.id, guess_evaluation, card_in_play,  flipped_card)}
		let(:card_in_play) { "7"}
		let(:flipped_card) { "8" }		
		let(:guess_evaluation) { "correct" }
		# let(:stub_change_status) { allow(Card).to receive(:change_old_card_in_play_status).with(new_game.id, card_in_play).and_return(true) }
		subject { determine_next_card  }

		context "the players guess_evaluation returned 'correct'" do
			let(:guess_evaluation) { "correct"}		
			
			it "sets the 'card in play' equal to the card that was just flipped" do
				# stub_change_status
				should == flipped_card
			end
		end
		
		






		context "the players guess_evaluation did NOT return 'correct'" do
			let(:flipped_card) { "7"}
			let(:guess_evaluation) { "same"}
			let(:next_flipped_card) {"11"}
			before(:each) do
				# stub_change_status
				allow(Card).to receive(:dealer_flips_card).with(new_game.id).and_return(next_flipped_card)
			end

			context "the players guess_evaluation returned 'same'" do
				let(:flipped_card) { "6"}
				let(:guess_evaluation) { "sweep"}		
				
				it "sets the 'card in play' equal to a newly flipped card" do
					should == next_flipped_card
				end
			end	

			context "the players guess_evaluation returned 'wrong'" do
				let(:flipped_card) { "6"}
				let(:guess_evaluation) { "wrong"}		
				
				it "sets the 'card in play' equal to a newly flipped card" do
					should == next_flipped_card
				end
			end		
		
			context "the players guess_evaluation returned 'same'" do
				let(:flipped_card) { "7"}
				let(:guess_evaluation) { "same"}		

				it "sets the 'card in play' equal to a newly flipped card" do
					should == flipped_card
				end
			end	

			context "the players guess_evaluation returned 'action card'" do
				let(:flipped_card) { "action_card"}
				let(:guess_evaluation) { "action_card"}		
				
				it "sets the 'card in play' equal to a newly flipped card" do
					should == card_in_play
				end
			end	

		end
	end





	# CHANGE THE OLD CARD_IN_PLAY STATUS - resets the original card_in_play's status
	# so that the flipped card can become the lone new "card in play"

	it { Card.should respond_to(:change_old_card_in_play_status) }
	
	describe "#change_old_card_in_play_status" do	
		before(:each) do
			@old_card = Card.where(game_id: new_game.id).first
			@old_card.status = "card_in_play"
			@old_card.save!

		end 

		it "changes the old_card_in_play's status to 'played'" do
			Card.change_old_card_in_play_status(@old_card.game_id)
			Card.find(@old_card.id).status.should == "played"
		end

		it "results in the deck having NO 'cards_in_play'" do
			Card.change_old_card_in_play_status(@old_card.game_id)
			Card.where(game_id: @old_card.game_id).where(status: "card_in_play").count.should == 0
		end


	end


	# AWARD THE POT - removes cards from the pot and awards them to the applicable player

	it { Card.should respond_to(:award_cards_in_the_pot) }

	describe "#award_cards_in_the_pot" do
		
		let(:guess_evaluation) { "wrong" }
		let(:current_player_number) { Player.where(game_id: @game_id).last.number }
		
		before(:each) do
			@game_id = new_game.id
			FactoryGirl.create(:player, name: "Abe", game_id: @game_id)
			FactoryGirl.create(:player, name: "Bill", game_id: @game_id, number: 2)
			FactoryGirl.create(:player, name: "Charlie", game_id: @game_id, number: 3)
			FactoryGirl.create(:player, name: "Dennis", game_id: @game_id, number: 4)
			FactoryGirl.create(:card, name: "7", card_order: 1, owner: "pot", game_id: @game_id)
			FactoryGirl.create(:card, name: "6", card_order: 2, owner: "pot", game_id: @game_id)
		end

	 	it "calls the 'Player.select_awardee'method" do
			expect(Player).to receive(:select_awardee).with(@game_id, current_player_number, guess_evaluation).and_return("Dennis")			
			Card.award_cards_in_the_pot(@game_id, current_player_number, guess_evaluation)
	 	end

	 	it "removes the cards from the pot" do
			allow(Player).to receive(:select_awardee).with(@game_id, current_player_number, guess_evaluation).and_return("Dennis")						
			Card.award_cards_in_the_pot(@game_id, current_player_number, guess_evaluation)
			Card.where(game_id: @game_id).where(owner: "pot").count.should == 0
	 	end
	 	
	 	context "the current player's guess was wrong" do
		 	it "awards the cards to the selected awardee" do
				allow(Player).to receive(:select_awardee).with(@game_id, current_player_number, guess_evaluation).and_return("Dennis")						
				Card.award_cards_in_the_pot(@game_id, current_player_number, guess_evaluation)
				Card.where(game_id: @game_id).where(owner: "Dennis").count.should == 2
		 	end
	 	end

	 	context "the current player chose to sweep the cards" do
		 	it "awards the cards to the current player" do
				allow(Player).to receive(:select_awardee).with(@game_id, current_player_number, "sweep").and_return("Abe")						
				Card.award_cards_in_the_pot(@game_id, current_player_number, "sweep")
				Card.where(game_id: @game_id).where(owner: "Abe").count.should == 2
		 	end
	 	end


	end



end
