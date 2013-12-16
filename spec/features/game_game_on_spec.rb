require 'spec_helper'

describe "Game_On Page" do

	describe "#View at Start of Game" do
		before(:each) do 
			visit root_path
			@player = FactoryGirl.build(:player, name: "Seth")
			input_name_and_click_lets_play
			@card_in_play = Card.where(status: "card_in_play").first.name
		end

		subject { page }
		
		it { should have_content("Current Player: #{@player.name}") }
		

		#it { should find_by_id("number") }   # this is a placeholder test, to_be refactored
		it { should have_content("Cards in Deck: 53") }
		it { should have_content("Cards in the Pot: 1 [\"#{@card_in_play}\"]") }
		it { should have_content("Card in Play: #{@card_in_play}")}
		it { should have_button("Higher") }
		it { should have_button("Lower") }
		it { should have_content("#{@player.name} - 0") }
		it { should have_content("Noah - 0") }
		it { should have_button("End Game")}
	end

	describe "#View After the Player's Guess" do
		before(:each) do
			@player1 = FactoryGirl.create(:player, name: "Abe", number: 1)
			@player2 = FactoryGirl.create(:player, name: "Bill", number: 2, game_id: @player1.game_id)
			@player3 = FactoryGirl.create(:player, name: "Charlie", number: 3, game_id: @player1.game_id)
			@player4 = FactoryGirl.create(:player, name: "Dennis", number: 4, game_id: @player1.game_id)
			@card_in_play = FactoryGirl.create(:card, game_id: @player1.game_id, name: "7", status: "card_in_play", owner: "pot", card_order: 1)
			visit "/game_on/#{@player1.game_id}/none/#{@player1.name}"				
		end		

		subject { page }

		context "the player want to end the game" do
			context "the players pushes the 'End Game' button" do
				it "returns the player to the root path" do
					click_on "End Game"
					current_path.should == root_path
				end
			end
		end
		
		context "the player wants to 'sweep' the cards from the pot" do
			
			context "there have been less than 3 consecutive correct guesses" do
				it { should_not have_button("Sweep") }
			end
			
			context "there have been at least 3 consecutive correct guesses in the current run" do
				before(:each) do
					game = Game.find(@player1.game_id)
					game.consecutive_correct_guesses = 3
					game.last_correct_guesser = last_player_to_guess_correctly
					game.save!
					# the card in play is a 7
					first_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "9", owner: "dealer", card_order: 2)
					second_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "8", owner: "dealer", card_order: 3)
					visit "/game_on/#{@player1.game_id}/none/#{@player1.name}"
					a_second_card_in_the_pot = FactoryGirl.create(:card, owner: "pot", status: "played", game_id: @player1.game_id)
					a_third_card_in_the_pot = FactoryGirl.create(:card, owner: "pot", status: "played", game_id: @player1.game_id)					
				end
				context "the current player has not input at least 1 correct guess in the current run" do
					let(:last_player_to_guess_correctly) { 2 }
					it { should_not have_button("Sweep")}
				end
				context "the current player has input at least 1 correct guess in the current run" do
					let(:last_player_to_guess_correctly) { 1 }
					it "should show the sweep button as an option" do
						should have_button("Sweep")
					end
					
					it "should award the cards in the pot to the current player" do
						click_on "Sweep"
						should have_content("Abe - 3")
					end

					it "adds the dealer-flipped-card to the pot" do
						click_on "Sweep"
						should have_content("Cards in the Pot: 1 [\"9\"]")
					end
					
					it "shows the next player in order as the 'Current Player'" do
						click_on "Sweep"
						should have_content("Current Player: #{@player2.name}")
					end
					
					it "should show zero correct guesses " do
						click_on "Sweep"
						should have_content("Consecutive Correct Guesses: 0")
					end
					
					xit { should have_content("Last Guess Was: sweep") }   #### Need to have this be a flash message before moving to the next player
					
					it "shows the dealer-flipped-card as the 'Card in Play'" do
						click_on "Sweep"
						should have_content("Card in Play: 9")	
					end
				end
			end
		end
	

		context "the player wants to guess higher or lower" do
			context "next card is higher than the current card" do
				before(:each) do
					# the card in play is a 7
					@first_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "9", owner: "dealer", card_order: 2)
					@second_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "8", owner: "dealer", card_order: 3)
				end

				context "player correctly guesses 'higher'" do
					before(:each) { click_on "Higher" }
					it "adds the next dealer-flipped-card to the pot" do
						should have_content("Cards in the Pot: 2 [\"9\", \"7\"]")
					end
					it { should have_content("Current Player: #{@player1.name}") }
					it { should have_content("Consecutive Correct Guesses: 1") }
					it { should have_content("Last Guess Was: correct") }
					it "shows the dealer-flipped-card as the new 'Card in Play'" do
						should have_content("Card in Play: 9")
					end
				end

				context "player incorrectly guesses lower" do
					before(:each) { click_on "Lower" }
					it "awards the cards in the pot and the dealer-flipped-card to the 4th player because of the incorrect guess" do
						should have_content("Dennis - 2")
					end
					it "adds the 'next' dealer-flipped-card to the pot" do
						should have_content("Cards in the Pot: 1 [\"8\"]")
					end
					it "shows the next player in order as the 'Current Player'" do
						should have_content("Current Player: #{@player2.name}")
					end
					it { should have_content("Consecutive Correct Guesses: 0") }
					it { should have_content("Last Guess Was: wrong") }   #### Need to have this be a flash message before moving to the next player
					it "shows the 'next' dealer-flipped-card as the 'Card in Play'" do
						should have_content("Card in Play: 8")	
					end
				end
			end
		end

	
	end

end

	
