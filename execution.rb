require_relative 'lib/controller'

number_of_players = 0

while number_of_players < 1 && number_of_players > 6
    puts "please select the number of players:"
    number_of_players = STDIN.gets.chomp.to_i
end

controller = Controller.new(number_of_players)

controller.play_game