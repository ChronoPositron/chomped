require 'url_hash/cleanup'
require 'url_hash/bad_words'
require 'damm/algorithm'
require 'hashids'

module UrlHash
  class Transform
    DEFAULT_ADDRESS_SPACE = '0123456890abcdfghijknprstuvwxyzACEGHJKLMNPQRUVWXY'.freeze
    DEFAULT_TRANSCRIPTIONS = [%w(lIT7 1), %w(oOD 0), %w(ZFqBmSe 2Eg8n5c)].freeze
    MINIMUM_ENCODED_LENGTH = 6

    attr_reader :address_space
    attr_reader :transcriptions
    attr_reader :cleanup
    attr_reader :checksum_algorithm
    attr_reader :bad_words

    def initialize(salt, options = {})
      address_space = options[:address_space] || DEFAULT_ADDRESS_SPACE
      transcriptions = options[:transcriptions] || DEFAULT_TRANSCRIPTIONS

      @address_space = address_space
      @transcriptions = transcriptions
      @cleanup = UrlHash::Cleanup.new(address_space, transcriptions)
      @checksum_algorithm = Damm::Algorithm.new(address_space.size)
      @bad_words = UrlHash::BadWords.new
      @hasher = Hashids.new(salt, MINIMUM_ENCODED_LENGTH - 1, @address_space)
    end

    # Convert the given string from characters to an array of code points.
    # Code points are the numeric index of the specified character within
    # the address space. So given an address space of 'abcd', 'a' has a code
    # point of 0, and 'd' has a code point of 3.
    def to_code_points(string)
      cleanup.scrub(string).chars.map { |c| address_space.index(c) }
    end

    # Convert from numeric code points to a string
    def from_code_points(array)
      [*array].map { |c| address_space[c] }.join('')
    end

    # Add a check character on the end of the input string
    def add_check(string)
      check_character = checksum_algorithm.calculate(to_code_points(string))
      string + from_code_points(check_character)
    end

    # Remove the check character from the end of the string if it's valid
    # and clean the string, providing a good string on success, and nothing
    # on failure.
    def remove_check(string)
      cleanup.scrub(string[0..-2]) if checksum_algorithm.valid?(to_code_points(string))
    end

    # Encode a given id into a checked, randomized string
    def encode(id)
      result = add_check(@hasher.encode([id]))

      i = 0
      until bad_words.clean?(result)
        result = add_check(@hasher.encode([id, i]))
        i += 1
      end

      result
    end

    # Decode a given checked string into its id
    # but only if it's valid. Return nil on invalid strings.
    def decode(string)
      @hasher.decode(remove_check(string))[0]
    end
  end
end
