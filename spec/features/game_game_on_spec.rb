require 'spec_helper'

describe "Game_on Page" do
	before(:each) { visit game_board_path	}

	subject { page }
	player = "Stewie"
	
	it "includes a personalized welcome heading" do
		within("h1") { should have_content("#{player}, welcome to Tuff Cookies!") }
	end
	
end
	