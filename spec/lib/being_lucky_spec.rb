require_relative '../../lib/being_lucky'

describe BeingLucky do
    let(:dice) { Array.new(5, Die.new) } 
    let(:scorer) { BeingLucky.new(dice) }
    let(:subject) { scorer }

    describe '#initialize' do
        it 'requires an array of dice objects' do
            scorer = BeingLucky.new([:die])
            expect(scorer.dice).to eq([:die])
        end

        it 'initialises with defaults' do
            expect(scorer.turn_score).to eq(0)
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

        context 'computes total score' do
            it 'adds the score to the total score if total score is over 300' do
                scorer.instance_variable_set(:@turn_score, 301)
                expect(scorer).to receive(:calculate_points).once.and_return(20)

                expect(scorer.score).to eq(20)
                expect(scorer.turn_score).to eq(321)
            end

            it 'adds the score to the total score if total score at 300' do
                scorer.instance_variable_set(:@turn_score, 300)
                expect(scorer).to receive(:calculate_points).once.and_return(20)

                expect(scorer.score).to eq(20)
                expect(scorer.turn_score).to eq(320)
            end

            it 'does not add the current score to the total score if current total is below 300' do
                expect(scorer.turn_score).to eq(0)
                expect(scorer).to receive(:calculate_points).once.and_return(20)

                expect(scorer.score).to eq(20)
                expect(scorer.turn_score).to eq(0)
            end
        end
    end

    describe '#calculate_points' do
        let(:all_non_scoring_dice) { [2,2,3,3,4] }
        let(:all_scoring_dice) { all_ones }
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
            expect(scorer.calculate_points([6,6,6,5,2])).to eq(650)
            expect(scorer.calculate_points([4,3,4,5,4])).to eq(450)
        end

        context 'removes dice' do
            it 'from future rolls if they were used to generate a score' do
                expect(scorer.calculate_points(all_scoring_dice))
                expect(scorer.dice.count).to eq(0)
            end

            it 'unless are non scoring' do 
                expect(scorer.calculate_points( all_non_scoring_dice))
                expect(scorer.dice.count).to eq(5)
            end
        end
    end

    describe '#convert_results_to_points' do
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

    describe '#add_to_total' do
        it 'adds any number if current total is at or over 300' do
            scorer.instance_variable_set(:@turn_score, 300)
            scorer.add_to_total(20)
            expect(scorer.turn_score).to eq(320)

            expect(scorer.turn_score).to be > (300)
            scorer.add_to_total(20)
            expect(scorer.turn_score).to eq(340)
        end

        it 'does not add a number smaller than 300 if the total is not at 300' do
            expect(scorer.turn_score).to eq(0)
            scorer.add_to_total(3)

            expect(scorer.turn_score).to eq(0)
        end

        it 'adds any number to total if greater than or equal to 300' do
            expect(scorer.turn_score).to eq(0)
            expect(scorer.add_to_total(300)).to eq(300)

            expect(scorer.turn_score).to eq(300)
        end
    end

    describe '#can_roll?' do
        it 'returns true if there are still dice to roll' do
            expect(scorer.dice.count).to eq(5)
            expect(scorer.can_roll?).to be_truthy
        end

        it 'returns false if there are no more non-scoring dice' do
            scorer = BeingLucky.new([])
            expect(scorer.dice).to be_empty
            expect(scorer.can_roll?).to be_falsey
        end
    end

    describe '#dice_count' do
        it 'returns the current amount of dice left' do
            expect(scorer.dice.count).to eq(scorer.dice_count)
        end
    end
end