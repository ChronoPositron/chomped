require 'rails_helper'
require 'url_hash/cleanup'

RSpec.describe UrlHash::Cleanup do
  def with_cleanup(address_space = '0123456890abcdfghijknprstuvwxyzACEGHJKLMNPQRUVWXY',
                   transcriptions = [%w(lIT7 1), %w(oOD 0), %w(ZFqBmSe 2Eg8n5c)])
    cleanup = UrlHash::Cleanup.new(address_space, transcriptions)
    yield(cleanup)
  end

  describe '#replace_transcription_errors' do
    context 'given a string with no transcription errors' do
      it 'should make no changes' do
        with_cleanup do |cleanup|
          expect(cleanup.replace_transcription_errors('CLEAN')).to eq('CLEAN')
        end
      end

      it 'should maintain a blank string' do
        with_cleanup do |cleanup|
          expect(cleanup.replace_transcription_errors('')).to eq('')
        end
      end
    end

    context 'given a string with transcription errors' do
      it 'should return the correct replacements' do
        with_cleanup do |cleanup|
          expect(cleanup.replace_transcription_errors('lIT7oODZFqBmSe')).to eq('11110002Eg8n5c')
        end
      end

      it 'should work with mixed text' do
        with_cleanup do |cleanup|
          expect(cleanup.replace_transcription_errors('This is a test')).to eq('1his is a tcst')
        end
      end
    end

    context 'given a basic set of options' do
      it 'should convert to numbers' do
        with_cleanup('0123456789', [%w(abcd 1234)]) do |cleanup|
          expect(cleanup.replace_transcription_errors('abcd5678')).to eq('12345678')
        end
      end
    end
  end

  describe '#remove_invalid_characters' do
    context 'given a completely valid string' do
      it 'should make no changes' do
        with_cleanup do |cleanup|
          expect(cleanup.remove_invalid_characters('CLEAN')).to eq('CLEAN')
        end
      end

      it 'should maintain a blank string' do
        with_cleanup do |cleanup|
          expect(cleanup.remove_invalid_characters('')).to eq('')
        end
      end
    end

    context 'given a string with invalid characters' do
      it 'should remove punctuation' do
        with_cleanup do |cleanup|
          expect(cleanup.remove_invalid_characters('!@#$%^&*()_+-=;:/?.>,<')).to eq('')
        end
      end

      it 'should remove spaces and transcription errors' do
        with_cleanup do |cleanup|
          expect(cleanup.remove_invalid_characters('This is a test')).to eq('hisisatst')
        end
      end
    end

    context 'given a numeric address space' do
      it 'should remove all non-numeric characters' do
        with_cleanup('0123456789', []) do |cleanup|
          expect(cleanup.remove_invalid_characters('This is a test')).to eq('')
        end
      end

      it 'should leave numeric characters' do
        with_cleanup('0123456789', []) do |cleanup|
          expect(cleanup.remove_invalid_characters('This 1 is a test 2')).to eq('12')
        end
      end
    end
  end

  describe '#scrub' do
    context 'given a completely clean string' do
      it 'should make no changes' do
        with_cleanup do |cleanup|
          expect(cleanup.scrub('CLEAN')).to eq('CLEAN')
        end
      end
    end

    context 'given a dirty string' do
      it 'should clean it up' do
        with_cleanup do |cleanup|
          expect(cleanup.scrub('This, is a test!!!')).to eq('1hisisatcst')
        end
      end
    end
  end

  describe '#character_overlaps?' do
    context 'given no overlaps' do
      it 'should find no overlaps' do
        expect(UrlHash::Cleanup.character_overlaps?('1234', [%w(abcd 1234)])).to be false
      end
    end

    context 'given overlaps' do
      it 'should find overlap' do
        expect(UrlHash::Cleanup.character_overlaps?('1234', [%w(1234 abcd)])).to be true
      end
    end
  end

  describe '#initialize' do
    context 'given an overlapping set of arguments' do
      it 'should raise an exception' do
        expect { UrlHash::Cleanup.new('1234', [%w(1234 abcd)]) }.to raise_error(ArgumentError)
      end
    end
  end
end
