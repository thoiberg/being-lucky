##
# object that takes an array of +Die+ objects and rolls them, calculating 
# the score of the turn.
class BeingLucky
    attr_reader :dice, :turn_score

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

    ## 
    # The minimum amount of points required to be added to the current running total
    # If neither the running total or current round are at or above the minimum then the 
    # points are not counted
    MINIMUM_POINTS = 300

    # @param [Die] dice an Array of Die objects
    def initialize(dice)
        @dice = dice
        @turn_score = 0
    end

    # A method to roll the dice and calculate the score of the turn based on
    # the game's scoring logic
    # @return [Integer] the current score of the round
    def score
        roll_results = @dice.map {|die| die.roll}
        points_this_turn = calculate_points(roll_results)
        add_to_total(points_this_turn)

        points_this_turn
    end

    # A method to calculate the points allocated based on the results of the
    # dice rolls. Any dice that generate a score are removed and any non-scoring
    # dice are kept to be rolled again.
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
        # returns a hash of dice value => frequency to be used to calculate scoring
        result_count = Hash[roll_results.group_by {|x| x}.map {|k,v| [k, v.count]}]

        result_count.each do |k,v|
            count = v  #TODO: check if I can just get away with using v

            while count > 0
                if count >= 3
                    point_total += convert_results_to_points(k, 3)
                    count -= 3
                    @dice.shift(3)
                elsif count >= 1
                    # TODO: Refactor. This is getting (is already) messy
                    points = convert_results_to_points(k, 1)
                    if points > 0
                        @dice.shift(1)
                        point_total += points
                    end

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

    ##
    # Adds the parameter to the +@total_score+ variable. As per the rules of the game it
    # only adds the points if the current total or supplied points are greater than 0.
    # If neither condition is met then the total score is not updated
    # @param [Integer] points the amount of points from the current turn
    # @return [Integer] current total_score
    def add_to_total(points)
        @turn_score += points if @turn_score >= MINIMUM_POINTS || points >= MINIMUM_POINTS
    end

    ##
    # Method to check if there are any dice left to roll
    # @return [Boolean] whether there are any dice left to roll
    def can_roll?
        dice_count > 0
    end

    ##
    # convience method to return the amount of dice left
    # @return [Integer] the amount of dice left to roll
    def dice_count
        @dice.count
    end



end