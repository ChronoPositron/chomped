module UrlHash
  class Cleanup
    attr_reader :address_space
    attr_reader :transcriptions

    def initialize(address_space, transcriptions)
      if Cleanup.character_overlaps?(address_space, transcriptions)
        raise ArgumentError, "Address space and transcripts cannot overlap"
      end

      @address_space = address_space
      @transcriptions = transcriptions
    end

    # Run a full cleaning
    def scrub(input)
      remove_invalid_characters(replace_transcription_errors(input))
    end

    # Some characters can be easily swapped when transcribing from printed media.
    # This replaces the most common of these problems with the chosen option.
    # Note: Anything that gets replaced in here should not be in the address space
    # of the url hash generation.
    def replace_transcription_errors(input)
      transcriptions.inject(input) do |work, transcription|
        work.tr(transcription[0], transcription[1])
      end
    end

    def remove_invalid_characters(input)
      input.tr("^#{address_space}", '')
    end

    # Check to make sure the address_space and transcriptions don't overlap.
    # Returns true if they overlap.
    def self.character_overlaps?(address_space, transcriptions)
      # Pull the first element of each sub array and put it into an array
      transcribed_chars = transcriptions.inject([]) { |arr, i| arr += i[0].chars }

      # Check for intersection between the address space and array we just put together.
      !(address_space.chars & transcribed_chars).empty?
    end
  end
end