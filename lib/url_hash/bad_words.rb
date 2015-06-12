module UrlHash
  class BadWords
    attr_accessor :all

    def initialize
      @all = BadWords.load
    end

    def self.load
      YAML.load_file(Rails.root.join('config/bad_words.yml'))[Rails.env]
    end

    # If the candidate string does not contain a bad word (case insensitive),
    # true will be returned. Overwise, false.
    def clean?(string)
      !all.any? { |s| string.downcase.include? s }
    end
  end
end
