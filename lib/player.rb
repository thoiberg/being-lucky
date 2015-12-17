##
# A class for each player of the game. The player's total score
# is kept here, along with a unique name
class Player
    @@player_count = 0

    attr_reader :name, :total_score

    ##
    # initializes an object of type Player. The name attribute is 
    # unique to each object
    def initialize
        @@player_count += 1
        @name = "Player #{@@player_count}"
        @total_score = 0
    end

    ##
    # adds the parameter to the total score for the player
    # @param [Integer] round_score the score for the round, to be added to the total
    # @return [Integer] the current total score
    def update_total_score(round_score)
        @total_score += round_score
    end
end