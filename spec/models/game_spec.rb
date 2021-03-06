require 'spec_helper'

describe Game do

	let(:new_game) { FactoryGirl.create(:game, consecutive_correct_guesses: 3, last_correct_guesser: 1)}

	# Testing Associations
	it { should have_many(:cards) }
	it { should have_many(:players) }

	it "has a valid factory" do 
  	FactoryGirl.create(:game).should be_valid
  end


	#TRACK CONSECUTIVE CORRECT GUESSES - keeps tabs on the number of consecutive correct guesses and who made the 
	#last correct guess
	
	it { Game.should respond_to(:track_consecutive_correct_guesses) } 
	
	describe "#track_consecutive_correct_guesses" do
		before(:each) do
			Game.track_consecutive_correct_guesses(new_game.id, guess_evaluation, 2)
			@calc_new_total = Game.find(new_game.id).consecutive_correct_guesses
		end

		context "player guess_evaluation returns 'correct'" do
			let(:guess_evaluation) { "correct" } 
			it "adds +1 to the consecutive_correct_guesses_total" do	
				@calc_new_total.should == 4
			end
		
			it "captures the number of the last player to guess correctly" do
				Game.find(new_game.id).last_correct_guesser.should == 2
			end
		end

		context "player guess_evaluation returns 'wrong'" do
			let(:guess_evaluation) { "wrong" }
			it "zeros out the consecutive_correct_guesses_total" do
				@calc_new_total.should == 0
			end
		end

		context "player guess_evaluation returns 'sweep'" do
			let(:guess_evaluation) { "sweep" }
			it "zeros out the consecutive_correct_guesses_total" do
				@calc_new_total.should == 0
			end
		end

		context "player guess_evaluation returns something OTHER THAN 'correct, wrong or sweep'" do
			let(:updated_total) { 3 }
			context "player guess_evaluation returns 'same'" do
				let(:guess_evaluation) { "same" }
				it "does not change the consecutive_correct_guesses_total" do
					@calc_new_total.should == updated_total
				end
			end

			context "player guess_evaluation returns 'action_card'" do
				let(:guess_evaluation) { "action_card" }
				it "does not change the consecutive_correct_guesses_total" do
					@calc_new_total.should == updated_total
				end
			end
		end

	end
end
