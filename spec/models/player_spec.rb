require 'spec_helper'

describe Player do
  
  # associations
  it { should belong_to(:game) }

  # factories
  it "has a valid factory" do 
  	FactoryGirl.create(:player).should be_valid
  end

 	it { Player.should respond_to(:create_player) }

 	describe "#create_player" do 
 		Player.create_player("Stu", FactoryGirl.create(:game))
 		it "creates a new player named 'Stu'" do
 			Player.last.name.should == "Stu"
 		end
 	end


end
