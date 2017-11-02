require_relative './parser'
require 'charguess'

module SRT
  class Load
    def initialize(spanish_srt_filename: , english_srt_filename:)
      File.file?(spanish_srt_filename) || raise(LoadError, "no such file to load -- #{spanish_srt_filename}")
      File.file?(english_srt_filename) || raise(LoadError, "no such file to load -- #{english_srt_filename}")
      puts combine_into_memory(load_into_hash(spanish_srt_filename, language: 'es'),
                          load_into_hash(english_srt_filename, language: 'en'))
    end

    def combine_into_memory(es_hash, en_hash)
      keys = [es_hash, en_hash].flat_map(&:keys).uniq.sort
      
    end

    # Refactor, to first convert the file to UTF-8 if necessary, and then use it from memory
    def load_into_hash(filename, language:)
      h = {}

      # we indicate that we read by paragraph separator "\r\n\r\n"
      encoding =  CharGuess.guess(IO.read(filename))
      File.read(filename, encoding: encoding).each_line("\r\n\r\n") do |paragraph|
        paragraph.encode!("UTF-8", encoding) if encoding != "UTF-8"

        # "346\r\n00:39:29,491 --> 00:39:32,559\r\nThat was \r\n a long time ago.\r\n\r\n"
        paragraph_id, timecode_and_span, *text = paragraph.split("\r\n")
        next if paragraph_id.to_i == 0
        # 00:39:29,491 --> 00:39:32,559
        timecode, timespan = timecode_and_span.split(" --> ")

        attrs = { timecode: timecode, timespan: timespan }
        attrs["paragraph_id_#{language}".to_sym] = paragraph_id.to_i
        attrs["text_#{language}".to_sym] = text
        timecode_in_ms = Parser.timecode_to_ms(timecode)
        h[timecode_in_ms] = attrs
      end
      h
    end

  end
end