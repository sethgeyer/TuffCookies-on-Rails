require 'spec_helper'

describe "Game_On Page" do

	before(:each) do 
		visit root_path
		@player = FactoryGirl.build(:player, game_id: 2)
		input_name_and_click_lets_play
	end

	subject { page }
	
	it { should have_content(@player.name) }
	it { should have_content(@player.score) }
#	it { should have_content(@player.game_id) }



	it { should have_content("Cards in Deck: 52") }


	
	
end
	