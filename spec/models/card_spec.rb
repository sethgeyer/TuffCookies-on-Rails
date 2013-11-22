require 'spec_helper'

describe Card do

	it { should belong_to(:game) }

	it { Card.should respond_to(:create_deck)}

	describe "#create_deck" do
			
		
		
		it "should create a deck of 52 cards" do
			Card.create_deck(FactoryGirl.create(:game))
			#need to specify that it should only be the cards associated w the particular game
			#need to consider a mock/stub.  Right now the numbers are incrementing up b 52 each time.
			Card.all.count.should == 52
		end

	end

end
