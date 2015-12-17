require_relative '../../lib/being_lucky'

describe BeingLucky do
    let(:dice) { Array.new(5, Die.new) } 
    let(:scorer) { BeingLucky.new(dice) }
    let(:subject) { scorer }

    describe '#initialize' do
        it 'requires an array of dice objects' do
            #require 'pry';binding.pry
            scorer = BeingLucky.new([:die])
            expect(scorer.dice).to eq([:die])
        end
    end

    describe '#score' do
        it 'rolls each die and returns the score for the round' do
            scorer.dice.each do |die|
                expect(die).to receive(:roll).once.and_return(1)
            end

            score = scorer.score
            expect(score).to be_a_kind_of(Integer)
        end
    end

    describe '#calculate_points' do
        let(:all_non_scoring_dice) { [2,2,3,3,4] }
        let(:all_ones) { [1,1,1,1,1] }

        it 'returns 0 if no scoring numbers are rolled' do
            expect(scorer.calculate_points(all_non_scoring_dice)).to eq(0)
        end

        it 'does not count numbers twice if they have multiple valid frequencies' do
            expect(scorer.calculate_points(all_ones)).to eq(1200)
        end

        it 'returns the scores of any rolls' do
            expect(scorer.calculate_points([1,1,5,5,2])).to eq(300)
            expect(scorer.calculate_points([5,2,2,1,2])).to eq(350)
            expect(scorer.calculate_points([3,3,3,2,6])).to eq(300)
        end
    end

    describe 'convert_results_to_points' do
        it 'takes the roll value and number of times it appears and converts it to points' do
            expect(scorer.convert_results_to_points(1,3)).to eq(1000)
            expect(scorer.convert_results_to_points(2,3)).to eq(200)
            expect(scorer.convert_results_to_points(3,3)).to eq(300)
            expect(scorer.convert_results_to_points(4,3)).to eq(400)
            expect(scorer.convert_results_to_points(5,3)).to eq(500)
            expect(scorer.convert_results_to_points(6,3)).to eq(600)
            expect(scorer.convert_results_to_points(1,1)).to eq(100)
            expect(scorer.convert_results_to_points(5,1)).to eq(50)
        end

        it 'returns 0 if the number combination does not have a point value' do
            expect(scorer.convert_results_to_points(1,5)).to eq(0)
            expect(scorer.convert_results_to_points(2,2)).to eq(0)
            expect(scorer.convert_results_to_points(3,1)).to eq(0)
        end
    end
end