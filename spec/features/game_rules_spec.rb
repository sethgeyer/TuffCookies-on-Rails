require 'spec_helper'

describe "Rules Page" do
	before(:each) { visit rules_path }	

	subject { page }
	
	it "includes a listing of rules" do
	 	within("h1") { should have_content("Rules") } 
	end
	
	it "links back to the welcome page" do
		click_on 'Back'
	 	current_path.should == root_path
	end



end
	
