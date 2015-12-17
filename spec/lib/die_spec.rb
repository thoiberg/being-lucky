require_relative '../../lib/die'

describe Die do 
    let(:subject) { Die.new }

    it { is_expected.to be_a_kind_of(Die) }

    describe '#roll' do
        it 'returns a random number between 1 and 6' do
            10_000.times do |roll|
                result = subject.roll
                expect(result).to be_a_kind_of(Integer)
                expect(result).to be <= 6
                expect(result).to be >= 1
            end
        end
    end
end