ENGLISH_LANGUAGE_VERBS_FILENAME = File.expand_path('../../word_lists/wordnet/verb.txt',__dir__)
require_relative './regular_verbs'
require_relative './irregular_verbs'


module ENGLISH_LANGUAGE
  class Verbs
    attr_reader :verb_list_filename

    def initialize(verb_list_filename = ENGLISH_LANGUAGE_VERBS_FILENAME)
      File.file?(verb_list_filename) || raise(LoadError, "no such file to load -- #{verb_list_filename}")
      @verb_list_filename = verb_list_filename
    end

    def expand(word)
      return nil unless is_a_verb?(word)
      irregular.expand(word) || ::ENGLISH_LANGUAGE::RegularVerbs.expand(word)
    end

    def is_a_verb?(word)
      @verb_list ||= parse
      @verb_list.include?(word)
    end

    def parse
      File.readlines(@verb_list_filename).map(&:chomp)
    end

    private

      def irregular
        @irregular ||= ::ENGLISH_LANGUAGE::IrregularVerbs.new
      end

  end
end
