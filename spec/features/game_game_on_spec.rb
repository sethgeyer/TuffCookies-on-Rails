require 'spec_helper'

describe "Game_On Page" do

	describe "#View at Start of Game" do
		before(:each) do 
			visit root_path
			@player = FactoryGirl.build(:player, name: "Seth")
			input_name_and_click_lets_play
			@card_in_play = Card.where(status: "card_in_play").first.card_name
		end

		subject { page }
		
		it { should have_content(@player.name) }
		it { should have_field("player_order") }   # this is a placeholder test, to_be refactored
		it { should have_content(@player.score) }
	#	it { should have_content(@player.game_id) }
		it { should have_content("Cards in Deck: 51") }
		it { should have_content("Cards in the Pot: 1 [\"#{@card_in_play}\"]") }
		it { should have_content("Card in Play: #{@card_in_play}")}
		it { should have_button("Higher") }
		it { should have_button("Lower") }
		it { should have_button("Sweep") }
		it { should have_content("#{@player.name} - #{@player.score}") }
		it { should have_content("Noah - 0") }
	end

	describe "#View after the player guess" do
		before(:each) do
			@player = FactoryGirl.create(:player, name: "Stu SecondVue")
			@card = FactoryGirl.create(:card, game_id: @player.game_id, status: "card_in_play", owner: "pot")
		end		

		subject { page }
		
		context " next card is higher than the current card" do
			before(:each) do
				@other_card_in_deck = FactoryGirl.create(:card, game_id: @player.game_id, card_name: "8", owner: "dealer")
				@another_card_in_deck = FactoryGirl.create(:card, game_id: @player.game_id, card_name: "9", owner: "dealer")
				visit "/game_on/#{@player.game_id}/4"				
			end
			context " player guesses higher" do
				before(:each) { click_on "Higher" }
				it "adds either an 8 or 9 to the pot" do
					should satisfy { has_content?("Cards in the Pot: 2 [\"8\", \"7\"]") or has_content?("Cards in the Pot: 2 [\"9\", \"7\"]") }
				end
				it { should have_content("Last Guess Was: correct") }
				it "shows either an 8 or 9 as the card_in_play" do
					should satisfy { has_content?("Card in Play: 8") or has_content?("Card in Play: 9") }
				end
			end
			context " player guesses lower" do
				before(:each) { click_on "Lower" }
				it "adds either an 8 or 9 to the pot" do
					should satisfy { has_content?("Cards in the Pot: 1 [\"8\"]") or has_content?("Cards in the Pot: 1 [\"9\"]") }
				end
				it { should have_content("Last Guess Was: wrong") }
				it "shows either an 8 or 9 as the card_in_play" do
					should satisfy { has_content?("Card in Play: 8") or has_content?("Card in Play: 9") }
				end
			end

		end

	end

end

	
