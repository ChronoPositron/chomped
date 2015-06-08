require 'damm/tables'

# Implement a basic Damm algorithm for calculating check digits.
# For more information, see:
# https://en.wikipedia.org/wiki/Damm_algorithm
# http://archiv.ub.uni-marburg.de/diss/z2004/0516/pdf/dhmd.pdf (Damm's dissertation, in German)
module Damm
  class Algorithm
    include Damm::Tables

    attr_reader :table

    def initialize(order)
      @table = get_tas_table(order)
    end

    # The resultant value is the check digit and should be appended
    # on the end of the input.
    def calculate(input)
      input.inject(0) { |interim, digit| table[interim][digit] }
    end

    def valid?(input)
      calculate(input) == 0
    end
  end
end