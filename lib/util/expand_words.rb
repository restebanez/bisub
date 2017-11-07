require_relative '../english_language/irregular_verbs'

module UTIL
  class ExpandWords
    attr_reader :file_path

    def initialize(file_path)
      File.file?(file_path) || raise(LoadError, "no such file to load -- #{file_path}")
      @file_path = file_path
      @irregular_verbs_instance = ::ENGLISH_LANGUAGE::IrregularVerbs.new
    end

    def perform
      File.open(file_path).each_line.inject([]) do |acc, line|
        if result = @irregular_verbs_instance.expand(line.chomp)
          acc << result
        else
          acc << line
        end
      end.join
    end

  end
end
