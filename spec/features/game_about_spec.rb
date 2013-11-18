require 'spec_helper'

describe "About Page" do
	before(:each) { visit about_path }	

	subject { page }
	
	it "includes an 'about us' summary" do
	 	within("h1") { should have_content("About") } 
	end
	
	it "links back to the welcome page" do
		click_on 'Back'
	 	current_path.should == root_path
	end



end