##
# object that takes an array of +Die+ objects and rolls them, calculating 
# the score of the turn.
class BeingLucky
    attr_reader :dice

    ##
    # Maps the face value on a die to the number of times it appears in a 5 die roll
    # to determine which combinations have values. +convert_results_to_points+ access 
    # this hash to quietly fail should the combination be invalid (not be worth any points)
    SCORE_MAP = {
        1 => {
            1 => 100,
            3 => 1000
            },
        2 => {
            3 => 200
            }, 
        3 => {
            3 => 300
            }, 
        4 => {
            3 => 400
            }, 
        5 => {
            1 => 50,
            3 => 500
            }, 
        6 => {
            3 => 600
            },  
    }

    # @param [Die] dice an Array of Die objects
    def initialize(dice)
        @dice = dice
    end

    # A method to roll the dice and calculate the score of the turn based on
    # the game's scoring logic
    # @return [Integer] the current score of the round
    def score
        roll_results = @dice.map {|die| die.roll}
        calculate_points(roll_results)
    end

    # A method to calculate the points allocated based on the results of the
    # dice rolls
    # Points are calculated using the following:
    #   | --------- | ----------- |
    #   | Three 1's | 1000 points |
    #   | Three 6's |  600 points |
    #   | Three 5's |  500 points |
    #   | Three 4's |  400 points |
    #   | Three 3's |  300 points |
    #   | Three 2's |  200 points |
    #   | One   1   |  100 points |
    #   | One   5   |   50 points |
    # @param [roll_results] roll_results an array containing the results of rolling the 5 die
    # @return [Integer] the point total for this round
    def calculate_points(roll_results)
        point_total = 0
        result_count = Hash[roll_results.group_by {|x| x}.map {|k,v| [k, v.count]}]

        result_count.each do |k,v|
            count = v  #TODO: check if I can just get away with using v

            while count > 0
                #require 'pry';binding.pry

                if count >= 3
                    point_total += convert_results_to_points(k, 3)
                    count -= 3
                elsif count >= 1
                    point_total += convert_results_to_points(k, 1)
                    #require 'pry';binding.pry
                    count -= 1
                end
            end
        end

        point_total
    end

    ##
    # Takes the roll value and the frequency it appears and returns the point value.
    # If no point value is assigned then 0 is returned
    # @param [Integer] value the number rolled
    # @param [Integer] frequency the amount of times the number was rolled
    # @return [Integer] the points value of rolling +value+ +frequency+ number of times
    def convert_results_to_points(value, frequency)
        SCORE_MAP.fetch(value, {}).fetch(frequency, 0)
    end



end