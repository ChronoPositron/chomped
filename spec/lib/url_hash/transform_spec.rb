require 'rails_helper'
require 'url_hash/transform'

RSpec.describe UrlHash::Transform do
  def default_transform
    UrlHash::Transform.new('this is my salt')
  end

  def custom_transform(address_space, transcriptions)
    UrlHash::Transform.new('this is my salt', address_space, transcriptions)
  end

  describe '#initialize' do
    it 'should have an address_space' do
      expect(default_transform.address_space).not_to be_blank
    end

    it 'should have a transcriptions array' do
      expect(default_transform.transcriptions).to be_an(Array)
    end
  end

  describe '#to_code_points' do
    context 'given a valid string' do
      it 'should convert numbers' do
        expect(default_transform.to_code_points('01234')).to eq([0, 1, 2, 3, 4])
      end

      it 'should work with characters' do
        expect(default_transform.to_code_points('CLEAN')).to eq([32, 38, 33, 31, 40])
      end
    end

    context 'given a string with invalid characters' do
      it 'should cleanup string and then convert' do
        expect(default_transform.to_code_points('Test this!'))
          .to eq([1, 12, 23, 24, 24, 16, 17, 23])
      end
    end
  end

  describe '#from_code_points' do
    context 'given valid array' do
      it 'should convert numbers' do
        expect(default_transform.from_code_points([0, 1, 2, 3, 4])).to eq('01234')
      end

      it 'should work with characters' do
        expect(default_transform.from_code_points([32, 38, 33, 31, 40])).to eq('CLEAN')
      end
    end

    context 'given single digit' do
      it 'should convert it' do
        expect(default_transform.from_code_points(32)).to eq('C')
      end
    end
  end

  describe '#add_check' do
    context 'given a valid string' do
      it 'should add the check character on the returned string' do
        expect(default_transform.add_check('CLEAN')).to eq('CLEANJ')
      end
    end

    context 'given a custom address space' do
      it 'should add a good check character' do
        expect(custom_transform('0123456789abcdefg', []).add_check('572')).to eq('5720')
      end
    end

    context 'given nil for transcriptions' do
      it 'should add a good check character using no transcriptions' do
        expect(custom_transform('0123456789abcdefg', nil).add_check('572')).to eq('5720')
      end
    end

    context 'given nil for address space' do
      it 'should use a blank address space, thus failing for not having a valid order size' do
        expect { custom_transform(nil, nil).add_check('') }.to raise_error(Damm::Tables::TableMissingError)
      end
    end
  end

  describe '#valid_check?' do
    context 'given a valid string' do
      it 'should succeed' do
        expect(default_transform.remove_check('CLEANJ')).to eq('CLEAN')
      end

      it 'should succeed with a custom address space' do
        expect(custom_transform('0123456789abcdefg', []).remove_check('5720')).to eq('572')
      end
    end

    context 'given an invalid string' do
      it 'should fail' do
        expect(default_transform.remove_check('CLEANK')).to be_nil
      end
    end
  end

  describe '#encode' do
    context 'given an id' do
      it 'should encode and add a check character' do
        expect(default_transform.encode(1)).to eq('bVy2QH')
      end
    end
  end

  describe '#decode' do
    context 'given a string' do
      it 'should decode a valid string' do
        expect(default_transform.decode('bVy2QH')).to eq(1)
      end

      it 'should return nil for an invalid string' do
        expect(default_transform.decode('bVy2QX')).to be_nil
      end
    end
  end
end
