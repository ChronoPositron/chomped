require 'rails_helper'
require 'damm/algorithm'

RSpec.describe Damm::Algorithm do
  describe '#calculate_check_digit' do
    context 'given a 10 digit order' do
      it 'should calculate a proper check digit' do
        expect(Damm::Algorithm.new(10).calculate([5, 7, 2])).to eq(4)
      end

      it 'should validate a check digit' do
        expect(Damm::Algorithm.new(10).valid?([5, 7, 2, 4])).to be true
      end
    end

    context 'given a 17 digit order' do
      it 'should calculate a proper check digit' do
        expect(Damm::Algorithm.new(17).calculate([5, 7, 2])).to eq(0)
      end

      it 'should validate a check digit' do
        expect(Damm::Algorithm.new(17).valid?([5, 7, 2, 0])).to be true
      end
    end

    context 'given a 49 digit order' do
      it 'should calculate a proper check digit' do
        expect(Damm::Algorithm.new(49).calculate([1, 27, 42])).to eq(16)
      end

      it 'should validate a check digit' do
        expect(Damm::Algorithm.new(49).valid?([1, 27, 42, 16])).to be true
      end
    end

    context 'given a 2 digit order' do
      it 'should fail. horribly.' do
        expect do
          Damm::Algorithm.new(2).calculate([5, 7, 2])
        end.to raise_error(Damm::Tables::InvalidOrderError)
      end
    end
  end
end
