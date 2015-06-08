require 'rails_helper'
require 'damm/tables'

RSpec.describe Damm::Tables do
  let(:damm_tables) { Class.new { include Damm::Tables } }

  describe '.get_tas_table' do
    # The standard example size
    it 'should work for order 10' do
      table = damm_tables.new.get_tas_table(10)
      expect(table.inject(0) { |sum, i| sum + i.size }).to eq(100)
    end

    # The size we use is also included
    it 'should work for order 49' do
      table = damm_tables.new.get_tas_table(49)
      expect(table.inject(0) { |sum, i| sum + i.size }).to eq(2401)
    end

    it 'should work for order 17' do
      table = damm_tables.new.get_tas_table(17)
      expect(table.inject(0) { |sum, i| sum + i.size }).to eq(289)
    end

    # This size doesn't work. Damm's dissertation is for order n =/= 2,6
    it 'should not work for order 6' do
      expect { damm_tables.new.get_tas_table(6) }.to raise_error(Damm::Tables::InvalidOrderError)
    end

    it 'should not work for order 3' do
      expect { damm_tables.new.get_tas_table(3) }.to raise_error(Damm::Tables::TableMissingError)
    end
  end
end
