require 'spec_helper'

describe Player do 
  it { should belong_to(:game) }

  it "has a valid factory" do 
  	FactoryGirl.create(:player).should be_valid
  end

  #CREATE PLAYERS - creates a list of players (1 actual, 3 virtual) 
  #for the game and assigns a number representing their "order of play" at
  #the start of the game.
 	it { Player.should respond_to(:create_players) }

 	describe "#create_players" do 
 		let(:new_game) { FactoryGirl.create(:game) }

 		before(:each) { Player.create_players("Stu", new_game) }

 		it "creates a new player named 'Stu'" do	
 		 Player.where(game_id: new_game.id).first.name.should == "Stu"
 		end
 	
		it "creates 3 additional virtual players" do
 		 Player.where(game_id: new_game.id).count.should == 4
 		end

		it "assigns player order of '1' to Stu and '3' to the third player" do
 		 Player.where(game_id: new_game.id).where(name: "Stu").first.number.should == 1
 		 Player.where(game_id: new_game.id).where(name: "Anne").first.number.should == 4
    end
 	end


  #DETERMINE THE NEXT PLAYER - determines who the player will be for the next hand
  it { Player.should respond_to(:determine_the_next_player) }

  describe "#determine_the_next_player" do
    before(:each) do
      @player1 = FactoryGirl.create(:player, name: "Abe",  number: 1)
      @player2 = FactoryGirl.create(:player, name: "Bill", number: 2, game_id: @player1.game_id)
      @player3 = FactoryGirl.create(:player, name: "Charlie", number: 3, game_id: @player1.game_id)
      @player4 = FactoryGirl.create(:player, name: "Dennis", number: 4, game_id: @player1.game_id)
    end
  
    context "the game's order of play is 'ascending'" do
      context "the guess evaluation returned 'wrong'" do
        context "the current player is the first player" do
          it "assigns the 'current_player' status to the second player" do
            Player.determine_the_next_player(@player1.game_id, 1, "wrong").should == "Bill"
          end
        end
        context "the current players is the last player" do
          it "assigns the 'current_player' status to the first player" do
            Player.determine_the_next_player(@player1.game_id, 4, "wrong").should == "Abe"
          end
        end
      end
      context "the guess evaluation returned 'correct'" do
        it "the 'current_player' status remains w/ the current player" do
          Player.determine_the_next_player(@player1.game_id, 1, "correct").should == "Abe"
        end
      end  
    end

    context "the game's order of play is 'descending'" do
      before(:each) do
        game = Game.find(@player1.game_id)
        game.direction = "descending"
        game.save!
      end

      context "the guess evaluation returned 'wrong'" do
        context "the current player is the first player" do
          it "assigns the 'current_player' status to the second player" do
      
            Player.determine_the_next_player(@player1.game_id, 1, "wrong").should == "Dennis"
          end
        end
        context "the current players is the last player" do
          it "assigns the 'current_player' status to the first player" do
            Player.determine_the_next_player(@player4.game_id, 4, "wrong").should == "Charlie"
          end
        end
      end
    end
  end


  # SELECT AWARDEE - identifies which player should receive the awarded cards in the pot

  it { Player.should respond_to(:select_awardee)}

  describe "#select_awardee" do
    
      context "the guess evaluation returned 'wrong'" do
        let(:guess_evaluation) { "wrong" }

        context "the current player is the 1st player" do
          let(:current_player) { FactoryGirl.create(:player, name: "Abe", number: 1) } 
          let(:current_player_number) { current_player.number }
         
          context "the game's order of play is 'ascending'" do
            it "should designate the fourth player as the awardee" do   
              awardee = FactoryGirl.create(:player, name: "Dennis", game_id: current_player.game_id, number: 4)
              Player.select_awardee(current_player.game_id, current_player_number, guess_evaluation).should == awardee.name
            end
          end
          
          context "the game's order of play is 'descending'" do
            before(:each) do
              game = Game.find(current_player.game_id)
              game.direction = "descending"
              game.save!
            end
            
            it "should designate the second player as the awardee" do
              awardee = FactoryGirl.create(:player, name: "Bill", game_id: current_player.game_id, number: 2)
              Player.select_awardee(current_player.game_id, current_player_number, guess_evaluation).should == awardee.name
            end
          end
        end
      end
    end
  end
