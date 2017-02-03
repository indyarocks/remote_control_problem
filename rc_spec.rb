####################################################################################################
# Autor: Chandan
# Date: 10/08/2013
# 
# Description: 
#    Test cases for RemoteControl class
#    
# Problem Description:
#    https://dl.dropboxusercontent.com/u/70915372/RemoteControl.docx
#
# Pre-Requisite: 
#    1. remote_control.rb
#    2. gem install rspec
#
# Run:
#    => rspec <test_filename.rb>
####################################################################################################

require_relative 'remote_control'


#====================================================================================================
#  Use Cases:
#====================================================================================================

describe "RemoteControl", "get_minimum_clicks_to_travel_watch_list" do 

  it "Should give the minimum number of click = 7" do 
  	RemoteControl.new("1 20", "2 18 19", "5 15 14 17 1 17").get_minimum_clicks_to_travel_watch_list.should == 7
  end	

  it "Should give the minimum number of click = 8" do 
  	RemoteControl.new("103 108", "1 104", "5 105 106 107 103 105").get_minimum_clicks_to_travel_watch_list.should == 8
  end	

  it "Should give the minimum number of click = 12" do 
  	RemoteControl.new("1 100", "4 78 79 80 3", "8 10 13 13 100 99 98 77 81")
  						.get_minimum_clicks_to_travel_watch_list.should == 12
  end	

  it "Should give the minimum number of click = 7" do 
  	RemoteControl.new("1 200", "0", "4 1 100 1 101").get_minimum_clicks_to_travel_watch_list.should == 7
  end	  
end	


#====================================================================================================
#  Test Cases For Validation of User input, i.e class initializers.
#====================================================================================================


# Test cases for lowest and higest channel number
describe "RemoteControl", "validate_channel_list" do 

  it "should have exactly two integer" do 
  	expect {RemoteControl.new("","1 1", "2 3 4")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("1","1 1", "2 3 4")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("1 100 210","1 1", "2 3 4")}.to raise_error(InvalidInputError)
  end	

  it "should have lowest channel greater than 0 and less than or equal to 10,000" do
  	expect {RemoteControl.new("-1 10","1 1", "2 3 4")}.to raise_error(InvalidInputError)
    expect {RemoteControl.new("0 10","1 1", "2 3 4")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("100000 10","1 1", "2 3 4")}.to raise_error(InvalidInputError)
  	RemoteControl.new("10 100","1 10", "2 12 14").should be_an_instance_of RemoteControl
  end

  it "should have highest channel greater than or equal to lowest channel and less than 10,000" do 
  	expect {RemoteControl.new("1000 100","1 1", "2 3 4")}.to raise_error(InvalidInputError)
    expect {RemoteControl.new("1000 19000","1 1", "2 3 4")}.to raise_error(InvalidInputError)
  	RemoteControl.new("1 10","1 1", "2 3 4").should be_an_instance_of RemoteControl
  	RemoteControl.new("100 100","0", "1 100").should be_an_instance_of RemoteControl
  end
end	

# Test cases for blocked channel lists
describe "RemoteControl", "validate_blocked_channel_list" do 

  it "should have channels between lowest channel and highest channel, both inclusive" do 
  	expect {RemoteControl.new("10 100","1 1000", "2 30 40")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("10 100","1 1", "2 30 40")}.to raise_error(InvalidInputError)
  	RemoteControl.new("10 100","1 20", "1 100").should be_an_instance_of RemoteControl
  	RemoteControl.new("10 100","0", "1 100").should be_an_instance_of RemoteControl
  end	

  it "should have the first number exactly maching the followed channel list size" do 
    expect {RemoteControl.new("10 100","1 11 10", "2 30 40")}.to raise_error(InvalidInputError)
    expect {RemoteControl.new("10 100","4 11 10", "2 30 40")}.to raise_error(InvalidInputError)
    RemoteControl.new("10 100","2 12 44", "1 100").should be_an_instance_of RemoteControl
  end	

  it "should ignore duplicate blocked channels" do 
  	RemoteControl.new("10 100","2 20 20", "1 100").should be_an_instance_of RemoteControl
  end	

  it "should have maximum 40 blocked channel" do
  	RemoteControl.new("10 100","0", "1 100").should be_an_instance_of RemoteControl
  	RemoteControl.new("10 100","", "1 100").should be_an_instance_of RemoteControl
  	RemoteControl.new("1 1000","40 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
  				24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 ", "1 100").should be_an_instance_of RemoteControl
    expect {RemoteControl.new("10 100","41 90", "2 30 40")}.to raise_error(InvalidInputError)
  end
end	

# Test cases for watch lists
describe "RemoteControl", "validate_to_watch_channel_list" do 

  it "should be between lowest and highest channel, both inclusive"	do 
  	expect {RemoteControl.new("10 100","1 10", "2 30 4")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("10 100","1 10", "2 20 200")}.to raise_error(InvalidInputError)
  	RemoteControl.new("10 1000","0", "2 100 110").should be_an_instance_of RemoteControl
  end	

  it "should be minimum 1 and maximum 50 viewable channel for Gaurav" do 
  	expect {RemoteControl.new("10 100","1 10", "")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("10 100","1 10", "0")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("10 100","1 10", "-1")}.to raise_error(InvalidInputError)
  	expect {RemoteControl.new("10 100","1 10", "51 232")}.to raise_error(InvalidInputError)
  	RemoteControl.new("1 1000","0", "50 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
  		23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50").should be_an_instance_of RemoteControl
  end	

  it "should not be in blocked channel list" do 
    expect {RemoteControl.new("10 100","1 10", "1 10")}.to raise_error(InvalidInputError)
    expect {RemoteControl.new("1 100","2 50 10", "5 88 54 73 44 10")}.to raise_error(InvalidInputError)
    RemoteControl.new("10 100","1 10", "1 100").should be_an_instance_of RemoteControl
  end	
end  	

#====================================================================================================
#  Test "Up Button", "Down Button" and "Back Button" minimum click functionality
#====================================================================================================

# Up Button Test
describe "RemoteControl", "get_min_up_click_count" do 

  before do 
    @remote_control = RemoteControl.new("1 200", "4 12 24 36 48", "5 11 100 1 101 198")
  end
    
  it "should no method error for private method get_min_up_click_count" do 
    expect {@remote_control.get_min_up_click_count(11, 11)}.to raise_error(NoMethodError)
  end	
    
  it "should return 0 if current channel and next channel are same" do 
    @remote_control.send(:get_min_up_click_count, 11, 11).should == 0
  end	

  it "should return 3 if current channel = 20 and next channel = 23" do 
    @remote_control.send(:get_min_up_click_count, 20, 23).should == 3
  end	  

  it "should return 4 if current channel = 198 and next channel = 2" do 
    @remote_control.send(:get_min_up_click_count, 198, 2).should == 4
  end	   
end	


# Down Button Test
describe "RemoteControl", "get_min_down_click_count" do 
  
  before do 
    @remote_control = RemoteControl.new("1 200", "4 12 24 36 48", "5 11 100 1 101 198")
  end

  it "should no method error for private method get_min_down_click_count" do 
    expect {@remote_control.get_min_down_click_count(11, 11)}.to raise_error(NoMethodError)
  end	
    
  it "should return 0 if current channel and next channel are same" do 
    @remote_control.send(:get_min_down_click_count, 11, 11).should == 0
  end	

  it "should return 4 if current channel = 2 and next channel = 198" do 
    @remote_control.send(:get_min_down_click_count, 2, 198).should == 4
  end	  

  it "should return 3 if current channel = 19 and next channel = 16" do 
    @remote_control.send(:get_min_down_click_count, 19, 16).should == 3
  end	
end	


# Back Button Test
describe "RemoteControl", "get_min_click_count_with_back" do 
  
  before do 
    @remote_control = RemoteControl.new("1 200", "4 12 24 36 48", "5 11 100 1 101 198")
  end

  it "should no method error for private method get_min_click_count_with_back" do 
    expect {@remote_control.get_min_click_count_with_back(11, 11)}.to raise_error(NoMethodError)
  end	
    
  it "should return 1 if current channel and next channel are same" do 
    @remote_control.send(:get_min_click_count_with_back, 11, 11).should == 1
  end	

  it "should return 3 if current channel = 200 and next channel = 198" do 
    @remote_control.send(:get_min_click_count_with_back, 200, 198).should == 3
  end	  

  it "should return 3 if current channel = 20 and next channel = 22" do 
    @remote_control.send(:get_min_click_count_with_back, 20, 22).should == 3
  end	
end	


#====================================================================================================
#  Test cases to get list of intermediate blocked channels
#====================================================================================================

describe "RemoteControl", "get_intermediate_blocked_channels" do 
  
  before do 
    @remote_control = RemoteControl.new("1 200", "4 12 24 36 48", "5 11 100 1 101 198")
  end

  it "should no method error for private method get_intermediate_blocked_channels" do 
    expect {@remote_control.get_intermediate_blocked_channels(10, 20, "up")}.to raise_error(NoMethodError)
    expect {@remote_control.get_intermediate_blocked_channels(10, 20, "down")}.to raise_error(NoMethodError)
  end	
    
  it "should return [] if current channel and next channel are same, click type = 'up'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 11, 11, "up").should == []
  end	

  it "should return [] if current channel and next channel are same, click type = 'down'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 11, 11, "down").should == []
  end	  

  it "should return [12] if current channel and next channel are same and equal to 12 , a blocked channel click type='up'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 12, 12, "up").should == [12]
  end	

  it "should return [12] if current channel and next channel are same and equal to 12 , a blocked channel click type='down'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 12, 12, "down").should == [12]
  end	

  it "should return [12,24,36,48] if current channel = 11 and next channel = 100, click type = 'up'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 11, 100, "up").should == [12,24,36,48]
  end	  

  it "should return [] if current channel = 11 and next channel = 100, click type = 'down'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 11, 100, "down").should == []
  end	

  it "should return [] if current channel = 100 and next channel = 1, click type = 'up'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 100, 1, "up").should == []
  end	  

  it "should return [12,24,36,48] if current channel = 100 and next channel = 1, click type = 'down'" do 
    @remote_control.send(:get_intermediate_blocked_channels, 100, 1, "down").should == [12,24,36,48]
  end	

end





