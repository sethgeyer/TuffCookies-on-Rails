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
		
		it { should have_content(@player.name) }
		it { should have_field("number") }   # this is a placeholder test, to_be refactored
		it { should have_content(0) }
	#	it { should have_content(@player.game_id) }
		it { should have_content("Cards in Deck: 51") }
		it { should have_content("Cards in the Pot: 1 [\"#{@card_in_play}\"]") }
		it { should have_content("Card in Play: #{@card_in_play}")}
		it { should have_button("Higher") }
		it { should have_button("Lower") }
		it { should have_button("Sweep") }
		it { should have_content("#{@player.name} - 0") }
		it { should have_content("Noah - 0") }
	end

	describe "#View after the player guess" do
		before(:each) do
			@player1 = FactoryGirl.create(:player, number: 1, name: "Stu SecondVue")
			@player2 = FactoryGirl.create(:player, name: "Noah", number: 2, game_id: @player1.game_id)
			@card_in_play = FactoryGirl.create(:card, game_id: @player1.game_id, name: "7", status: "card_in_play", owner: "pot", card_order: 1)
			visit "/game_on/#{@player1.game_id}/none"				
		end		

		subject { page }
		
		context " next card is higher than the current card" do
			before(:each) do
				@first_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "9", owner: "dealer", card_order: 2)
				@second_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "8", owner: "dealer", card_order: 3)
			end

			context " player guesses higher" do
				before(:each) { click_on "Higher" }
				it "adds the next card to the pot" do
					should have_content("Cards in the Pot: 2 [\"9\", \"7\"]")
				end
				it { should have_content("Last Guess Was: correct") }
				it "shows the next card as the new card_in_play" do
					should have_content("Card in Play: 9")
				end
			end

			context " player guesses lower" do
				before(:each) { click_on "Lower" }
				it "adds the 'next' next_card card to the pot" do
					should have_content("Cards in the Pot: 3 [\"8\", \"9\", \"7\"]")
				end
				it { should have_content("Last Guess Was: wrong") }
				# it "shows shows the 'next' next_card as the card_in_play" do
				# 	should have_content("Card in Play: 8")	
				# end
				# it { should have_content("Noah - 2") }
			end
		end


		context " next card is lower than the current card" do
			before(:each) do
				@first_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "6", owner: "dealer", card_order: 2)
				@second_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "5", owner: "dealer", card_order: 3)
			end

			context " player guesses lower" do
				before(:each) { click_on "Lower" }
				it "adds the next card to the pot" do
					should have_content("Cards in the Pot: 2 [\"6\", \"7\"]")
				end
				it { should have_content("Last Guess Was: correct") }
				it "shows the next card as the new card_in_play" do
					should have_content("Card in Play: 6")
				end
			end


			context " player guesses higher" do
				before(:each) { click_on "Higher" }
				# it "adds the next card to the pot" do
				# 	should have_content("Cards in the Pot: 2 [\"9\", \"7\"]")
				# end
				it { should have_content("Last Guess Was: wrong") }
				# it "shows the next card as the new card_in_play" do
				# 	should have_content("Card in Play: 9")
				# end
			end
		end

		context " next card is the same as the the current card" do
			before(:each) do
				@first_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "7", owner: "dealer", card_order: 2)
				@second_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "5", owner: "dealer", card_order: 3)
			end

			context " player guesses lower" do
				before(:each) { click_on "Lower" }
				it "adds the next card to the pot" do
					should have_content("Cards in the Pot: 2 [\"7\", \"7\"]")
				end
				it { should have_content("Last Guess Was: same") }
				it "shows the next card as the new card_in_play" do
					should have_content("Card in Play: 7")
				end
			end
		end

		# context " next card is the same as the the current card" do
		# 	before(:each) do
		# 		@first_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "war_card", owner: "dealer", card_order: 2)
		# 		@second_card_in_deck = FactoryGirl.create(:card, game_id: @player1.game_id, name: "5", owner: "dealer", card_order: 3)
		# 	end

		# 	context " player guesses lower" do
		# 		before(:each) { click_on "Lower" }
		# 		it "adds the next card to the pot" do
		# 			should have_content("Cards in the Pot: 2 [\"7\", \"7\"]")
		# 		end
		# 		it { should have_content("Last Guess Was: same") }
		# 		it "shows the next card as the new card_in_play" do
		# 			should have_content("Card in Play: 7")
		# 		end
		# 	end
		# end




	end

end

	
