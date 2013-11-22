require 'spec_helper'

describe "Game_Board Page" do
	before(:each) { visit game_board_path	}

	subject { page }
	player = "Seth"
	
	it "includes a personalized welcome heading" do
		within("h1") { should have_content("#{player}! Welcome to Tuff Cookies!") }
	end
	
end
	