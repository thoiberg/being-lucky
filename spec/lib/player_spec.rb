require_relative '../../lib/player'

describe Player do
    let(:player) { Player.new }

    describe '#initialize' do
        it 'generates a unique name' do
            players = []
            100.times {|x| players << Player.new }
            expect(players.uniq {|p| p.name}.count).to eq(100)
        end

        it 'gives a default total_score of 0' do
            expect(Player.new.total_score).to eq(0)
        end
    end

    describe '#update_score' do 
        it 'adds the number to the total score' do
            expect(player.total_score).to eq(0)
            player.update_total_score(200)

            expect(player.total_score).to eq(200)
        end
    end
end