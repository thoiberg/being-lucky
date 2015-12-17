
require_relative '../../lib/controller'

describe Controller do
    let(:controller) { Controller.new(3) }
    let(:subject) { controller } 
    describe '#initialize' do
        it 'requires the number of players' do
            control = Controller.new(3)
            expect(control.players.count).to eq(3)
        end

        it 'creates a player object for each person' do
            controller.players.each do |player|
                expect(player).to be_a_kind_of(Player)
            end
        end
    end


    describe '#play_game' do
        it 'plays a round for every person', test: true do
            expect(controller).to receive(:play_round).at_least(3).times.and_return(200,500,0)

            controller.play_game

            expect(controller.players[0].total_score).to eq(200)
        end
    end

    describe '#play_round' do

        it 'plays the round and returns the score' do
            expect(STDOUT).to receive(:puts).at_least(:once)
            expect(STDIN).to receive(:gets).and_return('n')
            expect(controller.play_round).to be_a_kind_of(Integer)
        end

        it 'returns 0 if the user no longer has any rollable dice' do
            # Yuck
            expect_any_instance_of(BeingLucky).to receive(:can_roll?).and_return(true, false)
            expect(STDOUT).to receive(:puts).at_least(:once)
            expect(controller.play_round).to eq(0)
        end
    end

    describe '#begin_final_round?' do
        it 'returns true if a player has a high enough score' do
            controller.players.first.update_total_score(10000)

            expect(controller.begin_final_round?).to be_truthy
        end

        it 'returns false if no players have a high enough score' do
            controller.players.each {|player| expect(player.total_score).to be < 3000}
            expect(controller.begin_final_round?).to be_falsey
        end
    end
end