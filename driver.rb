####################################################################################################
# Autor: Chandan
# Date: 10/08/2013
# 
# Description: 
#    Returns minimum number of clicks required to switch a given set of channels in the given order.
#    Skips blocked channels. 
#    
# Problem Description:
#    https://dl.dropboxusercontent.com/u/70915372/RemoteControl.docx
#
# Pre-Requisite: 
#    1. remote_control.rb
#
# Inputs:
#    This program takes three inputs from user:
#    1. First input will contain two space delimited numbers, these will form the lowest channel and 
#       the highest channel. 
#    2. Number of blocked channels followed by sequence of blocked channels (space delimited)
#    3. Number of watch list channels followed by sequence of channels that user must view.(space delimited)
# 
# Output:
#    Prints Minimum number of clicks to get through all the shows
# Run:
#    => ruby <filename.rb>
####################################################################################################
require_relative 'remote_control.rb'


puts "Please enter lowest and highest channel."
available_channels = gets.chomp

puts "Please enter number of blocked channels and space separated blocked channel list."
blocked_channels = gets.chomp

puts "Please enter number of viewable channel and space separated viewable channel list in order."
viewable_channels = gets.chomp

begin
  remote = RemoteControl.new(available_channels,blocked_channels,viewable_channels)
  min_clicks = remote.get_minimum_clicks_to_travel_watch_list
  puts "#"*100
  puts "Minimum Clicks Required = #{min_clicks}"
  puts "#"*100
rescue Exception => e
  puts "#"*100
  puts "# #{e.message} #"
  puts "#"*100
end	
