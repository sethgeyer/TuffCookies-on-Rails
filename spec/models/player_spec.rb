require 'spec_helper'

describe Player do
  
  # associations
  it { should belong_to(:game) }

  # factories
  it "has a valid factory" do 
  	FactoryGirl.create(:player).should be_valid
  end

 	

  #CREATE PLAYERS - creates a list of players (1 actual, 3 virtual) 
  #for the game and assigns an order of play
 	it { Player.should respond_to(:create_players) }

 	describe "#create_players" do 
 		let(:game) { FactoryGirl.create(:game) }
 		before(:each) { Player.create_players("Stu", game) }
 		
 		it "creates a new player named 'Stu'" do	
 			Player.first.name.should == "Stu"
 		end
 	
		it "creates 3 additional virtual players" do
 			Player.where(game_id: game.id).count.should == 4
 		end

		it "assigns player order" do
 			Player.where(game_id: game.id).where(name: "Stu").first.player_order.should == 1
 		end



 	end


end
