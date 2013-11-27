require 'spec_helper'

describe "Game_On Page" do

	before(:each) do 
		visit root_path
		@player = FactoryGirl.build(:player, name: "Seth")
		input_name_and_click_lets_play
		@flipped_card = 7
	end

	subject { page }
	
	it { should have_content(@player.name) }
	it { should have_content(@player.score) }
#	it { should have_content(@player.game_id) }
	it { should have_content("Cards in Deck: 51") }
	it { should have_content("Cards in the Pot: ")}
#??? What is the best way to test the random creation of card?
#	it { should have_content("Card in Play: #{@flipped_card}")}
	it { should have_button("Higher") }
	it { should have_button("Lower") }
	it { should have_button("Sweep") }

	describe "#Score Summary Section" do
		it { should have_content("#{@player.name} - #{@player.score}") }
		it { should have_content("Noah - 0") }
	end

end
	
