require_relative 'being_lucky'
require_relative 'die'

##
# A top level class to control the flow of the game. This class
# is responsible for setting up the scoring, the people and for
# communicating back to the players.
class Controller
    attr_reader :players

    ##
    # the point threshold to begin the final round. Once any player reaches
    # the threshold all players are given a final round then the results are tallied
    FINAL_ROUND_THRESHOLD = 3000

    ##
    # Creates an object of Controller type. 
    # @param [Integer] number_of_players The number of players participating in the game
    def initialize(number_of_players)
        @players = []
        number_of_players.times {|n| @players << Player.new}
    end

    ##
    # plays the game. Does not return any data but outputs text to the screen
    # for player feedback
    def play_game
        @players.each do |player|
            player.update_total_score(play_round)
        end
    end

    ##
    # plays the round for a single player.
    # @return [Integer] the score for the round for the player
    def play_round
        scorer = BeingLucky.new(Array.new(5, Die.new))

        while scorer.can_roll?
            roll_score = scorer.score
            puts "Score for this roll: #{roll_score}"
            puts "Score for this round: #{scorer.turn_score}"
            puts "Dice left to roll: #{scorer.dice_count}"

            unless scorer.can_roll?
                puts "You lose! No more dice means no points this round"
                return 0
            end

            puts "roll again? (Y/N): "
            if STDIN.gets.chomp.downcase == "n"
                # cash out the points and break the loop
                return scorer.turn_score
            end

        end

    end

    ##
    # checks to see if any players have reached the threshold to begin the final round
    # @return [Boolean] returns true if any players have a total score at or above FINAL_ROUND_THRESHOLD
    def begin_final_round?
        @players.any? {|player| player.total_score >= FINAL_ROUND_THRESHOLD}
    end
end