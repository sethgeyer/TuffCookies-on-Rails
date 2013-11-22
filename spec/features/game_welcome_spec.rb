require 'spec_helper'

describe "Welcome Page" do
	before(:each) { visit root_path	}

	subject { page }
	
	it "includes a welcome heading" do
		within("h1") { should have_content("Welcome to Tuff Cookies!") }
	end
	
	it "kicks off the game when the user inputs their name" do
		fill_in "player_name", with: "Seth"
		click_on "Let's Play!"
		current_path.should == game_board_path
	end

	it "links to a 'rules' page" do
		click_on 'Rules'
		current_path.should == rules_path
	end

	it "links to an 'about' page" do
		click_on 'About'
		current_path.should == about_path
	end


end
	
