####################################################################################################
# Autor: Chandan
# Date: 10/08/2013
# 
# Description: 
#    RemoteControl class.
#    This class can be used by driver program with the correct set of input arguments.
#    Invalid Input will throw "InvalidInputError" exception.
#    
####################################################################################################

# Custom Exception Class
InvalidInputError = Class.new(ArgumentError)

# Define digits method for Integer class
# Returns the number of digits in an integer
class Integer
  def digits
    self.to_s.size
  end
end


# RemoteControl class
class RemoteControl

  LOWEST_CHANNEL = 1
  HIGHEST_CHANNEL = 10_000

  # Initializes RemoteControl class. For invalid input, throws an exception of "InvalidInputError" type.
  def initialize(available_channel_list_in, blocked_channel_list_in, to_watch_channel_list_in)
    valid_list = validate_channel_list(available_channel_list_in)
    if valid_list[:success]
      @lowest_channel, @highest_channel = valid_list[:lowest_channel], valid_list[:highest_channel]
    else
      raise InvalidInputError.new("#{valid_list[:message]}")
    end
    blocked_channel_list = validate_blocked_channel_list(blocked_channel_list_in, @lowest_channel, @highest_channel)
    if blocked_channel_list[:success]
      @blocked_channels = blocked_channel_list[:blocked_channels]
    else
      raise InvalidInputError.new("#{blocked_channel_list[:message]}")
    end
    to_watch_channel_list = validate_to_watch_channel_list(to_watch_channel_list_in, @lowest_channel, @highest_channel, @blocked_channels)
    if to_watch_channel_list[:success]
      @watch_list = to_watch_channel_list[:watch_list]
    else
      raise InvalidInputError.new("#{to_watch_channel_list[:message]}")
    end
  end



  # Instance method to get minimum number of clicks for a RemoteControl class object.
  def get_minimum_clicks_to_travel_watch_list
    # First channel has to be clicked based on number of digits in channel
    clicks = @watch_list[0].digits

    # Move from current channel to next channel with minimum number of clicks.
    @watch_list.each_with_index do |current_channel,index|

      next_channel = @watch_list[index+1]
      previous_channel = @watch_list[index-1]

      # Check if there is next channel.
      unless next_channel.nil?
        # No clicks required if next channel is same as the current channel	
        next if current_channel == next_channel

        min_no_of_direct_clicks_req = next_channel.digits

        min_no_of_up_clicks_req = get_min_up_click_count(current_channel, next_channel)

        min_no_of_down_clicks_req = get_min_down_click_count(current_channel, next_channel)

        min_of_direct_up_down = [min_no_of_direct_clicks_req, min_no_of_up_clicks_req, min_no_of_down_clicks_req].min

        # There is no Back functionality for First Channel.
        min_no_of_clicks_req_using_back = get_min_click_count_with_back(previous_channel, next_channel) unless index == 0

        clicks += (index == 0) ? min_of_direct_up_down : [min_of_direct_up_down, min_no_of_clicks_req_using_back].min
      end
    end
    return clicks
  end


  private

  # Method to get minimum number of "Up Button" click to go from current_channel to next_channel.
  def get_min_up_click_count(current_channel, next_channel)
    return 0 if current_channel == next_channel

    intermediate_blocked_channel_count = get_intermediate_blocked_channels(current_channel, next_channel, "up").count

    if current_channel < next_channel
      click_counts = (next_channel - current_channel) - intermediate_blocked_channel_count
    else
      click_counts = (@highest_channel - current_channel + next_channel - (@lowest_channel - 1)) - intermediate_blocked_channel_count
    end
  end


  # Method to get minimum number of "Down Button" click to go from current_channel to next_channel.
  def get_min_down_click_count(current_channel, next_channel)
    return 0 if current_channel == next_channel

    intermediate_blocked_channel_count = get_intermediate_blocked_channels(current_channel, next_channel, "down").count

    if current_channel > next_channel
      click_counts = (current_channel - next_channel) - intermediate_blocked_channel_count
    else
      click_counts = (current_channel - @lowest_channel + @highest_channel - (next_channel - 1)) - intermediate_blocked_channel_count
    end
  end


  # Method to get minimum number of button clicks to go from current_channel to next_channel using "Back Button".
  def get_min_click_count_with_back(previous_channel, next_channel)
    # One click to go "Back Button"
    click_counts = 1
    # Return click count as one if previous channel is the next channel
    return click_counts if previous_channel == next_channel

    min_up_click_count = get_min_up_click_count(previous_channel, next_channel)
    min_down_click_count = get_min_down_click_count(previous_channel, next_channel)

    click_counts += [min_up_click_count, min_down_click_count].min
  end


  # Method to get array of blocked channel between "channel1" and "channel2" based on user clicks (Up or Down)
  def get_intermediate_blocked_channels(channel1, channel2, click_type)
  	
  	return [channel1] & @blocked_channels if channel1 == channel2

    if click_type == "up"
      intermediate_channels = (channel1 < channel2) ? (channel1..channel2).to_a : ((channel1..@highest_channel).to_a + (@lowest_channel..channel2).to_a)
    elsif click_type == "down"
      intermediate_channels = (channel1 < channel2) ? ((@lowest_channel..channel1).to_a + (channel2..@highest_channel).to_a ): (channel2..channel1).to_a
    end

    return intermediate_channels & @blocked_channels
  end


  # Validates the lowest and highest channel numbers
  def validate_channel_list(available_channel_list)
    # Split the input string and also check if the given inputs are integer. 
    begin
      channels = available_channel_list.split(" ").collect {|channel| Integer(channel)}
    rescue
      return {:success => false,
              :message => "Please provide two space separated integer values for lowest and highest channel.",
              :lowest_channel => nil,
              :highest_channel => nil}
    end

    return {:success => false,
            :message => "Please provide two space separated integer values for lowest and highest channel.",
            :lowest_channel => nil,
            :highest_channel => nil} unless channels.count == 2

    lowest_channel, highest_channel = channels


    unless (LOWEST_CHANNEL..HIGHEST_CHANNEL).include?(lowest_channel)
      return {:success => false,
              :message => "The lowest channel must be an integer greater than #{LOWEST_CHANNEL} and less than equal to #{HIGHEST_CHANNEL}",
              :lowest_channel => nil,
              :highest_channel => nil}
    end

    unless (lowest_channel.to_i..HIGHEST_CHANNEL).include?(highest_channel)
      return {:success => false,
              :message => "The highest channel must be an integer greater than or equal to lowest channel#{lowest_channel} and less than equal to #{HIGHEST_CHANNEL}",
              :lowest_channel => nil,
              :highest_channel => nil}
    end

    return {:success => true,
            :message => "",
            :lowest_channel => lowest_channel,
            :highest_channel => highest_channel}
  end


  # Validates the blocked channel numbers and list
  def validate_blocked_channel_list(blocked_channel_list, lowest_channel, highest_channel)
  	# Split the input string and also check if the given inputs are integer. 
    begin
      blocked_channels = blocked_channel_list.split(" ").collect {|channel| Integer(channel)}
      num_of_blocked_channels = blocked_channels.shift.to_i  # Get the first number out of blocked_list array.
    rescue
      return {:success => false,
              :message => "Please provide integer values for total number of blocked channel and blocked channels.",
              :blocked_channels => []}
    end

    return {:success => false,
            :message => "The number of blocked channels list can have maximum upto 40 channels.",
            :blocked_channels => []} if num_of_blocked_channels > 40

    return {:success => false,
            :message => "The total number of blocked channels #{num_of_blocked_channels} and count of given blocked channels #{blocked_channels} doesn't match.",
            :blocked_channels => []} if num_of_blocked_channels != blocked_channels.size

    return {:success => false,
            :message => "Blocked channels must lie between lowest(#{lowest_channel}) and highest(#{highest_channel}) channels.",
            :blocked_channels => []} if (blocked_channels.max.to_i > highest_channel || blocked_channels.min.to_i < lowest_channel) && num_of_blocked_channels > 0

    return {:success => true,
            :message => "",
            :blocked_channels => blocked_channels}

  end



  def validate_to_watch_channel_list(to_watch_channel_list, lowest_channel, highest_channel, blocked_channels)
  	# Split the input string and also check if the given inputs are integer. 
    begin
      watch_list = to_watch_channel_list.split(" ").collect {|channel| Integer(channel)}
      num_of_watch_channels = watch_list.shift.to_i  # Get the first number out of watch_list array.
    rescue
      return {:success => false,
              :message => "Please provide integer values for total number of watch channels and to watch channels.",
              :watch_list => []}
    end

    return {:success => false,
            :message => "The watch channel must not contain blocked channels.",
            :blocked_channels => []} if (watch_list & blocked_channels).size > 0

    return {:success => false,
            :message => "The watch channel list must contain at least 1 channel and maximum upto 50 channels.",
            :blocked_channels => []} if num_of_watch_channels < 1 || num_of_watch_channels > 50

    return {:success => false,
            :message => "The total number of watch channel list #{num_of_watch_channels} and count of watch channels #{watch_list} doesn't match.",
            :blocked_channels => []} if num_of_watch_channels != watch_list.size

    return {:success => false,
            :message => "To watch channel must lie between lowest(#{lowest_channel}) and highest(#{highest_channel}) channels.",
            :blocked_channels => []} if (watch_list.max.to_i > highest_channel || watch_list.min.to_i < lowest_channel) && num_of_watch_channels > 0

    return {:success => true,
            :message => "",
            :watch_list => watch_list}
  end
end
