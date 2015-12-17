##
# A class for simulating a Die. can be "rolled" to generate a
# random number between 1 and 6
class Die

    ## 
    # randomly generates a number between 1 and 6, simulating a die roll
    # @return [Integer] number between 1 and 6, symbolising the face up side of a die
    def roll
        Random.rand(1..6)
    end
end
