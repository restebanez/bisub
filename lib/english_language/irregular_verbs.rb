ENGLISH_LANGUAGE_IRREGULAR_VERBS_FILENAME = File.expand_path('../../word_lists/basic_english/irregular_verbs.txt',__dir__)
# To be is a special case be (am, is, are) – was, were – been
module ENGLISH_LANGUAGE
  class ParserError < StandardError; end

  class IrregularVerbs

    attr_reader :file_word_list

    def initialize(file_word_list = ENGLISH_LANGUAGE_IRREGULAR_VERBS_FILENAME)
      File.file?(file_word_list) || raise(LoadError, "no such file to load -- #{file_word_list}")
      @file_word_list = file_word_list
    end

    # it returns a hash {infinitive: "bend",
    #                    past: ["bent", "bended"],
    #                    participle: ["bent", "bended"]}
    def expand(infinitive)
      return nil unless (conjugations = list_by_infinitive[infinitive])
      txt = []
      past_tenses, past_participles = conjugations
      txt << "#{infinitive} (v)"
      txt << past_tenses.map { |v| "#{v} (v past)"}
      txt << past_participles.map { |v| "#{v} (v participle)"}
      txt.flatten.join("\n") + "\n"
    end

    # find("bent") -> :past_participle
    # find("hello") -> nil
    def find(any_verb_form)
    end

    def list_by_infinitive
      @list ||= parse
      @list_by_infinitive_cached ||= @list.inject({}) {|h_list, (i,pt,pp)| h_list.merge({i => [pt,pp] }) }
    end

    def parse
      File.open(file_word_list).each_line.each_with_index.map do |line, i|
        if /(?<infinitive>\w+),(?<past_tense_all>[a-z()\/-]+),(?<past_participle_all>[a-z()\/-]+)/ =~ line
          past_tense_all = '' if past_tense_all == '(none)'
          past_participle_all = '' if past_participle_all == '(none)'
          [infinitive, past_tense_all.split('/'), past_participle_all.split('/')]
        else
          raise ParserError, "Failed to parse irregular verb on line #{i}: #{line}"
        end
      end
    end
  end
end
