require 'spec_helper'

describe "Welcome Page" do
	

	before(:each) do 
		visit root_path

		
	end

	subject { page }
	
	it "includes a welcome heading" do
		within("h1") { should have_content("Welcome to Tuff Cookies!") }
	end

	it "links to a 'rules' page" do
		click_on 'Rules'
		current_path.should == rules_path
	end

	it "links to an 'about' page" do
		click_on 'About'
		current_path.should == about_path
	end

	# it "it links to 'game_on' page when player inputs name" do
	# 	fill_in "player_name", with: "Stew"
	# 	click_on "Let's Play"
	# 	current_path.should == game_on_path(game_id, evaluation
	# end
#???? WHAT IS THE BEST WAY TO TEST A PATH WITH A PASSED NAMED PARAMETER IN THE PATHNAME?


end
	
