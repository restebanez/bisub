require_relative './parser'
require 'charlock_holmes'

module SRT
  class Load
    def initialize(spanish_srt_filename: , english_srt_filename:)
      File.file?(spanish_srt_filename) || raise(LoadError, "no such file to load -- #{spanish_srt_filename}")
      File.file?(english_srt_filename) || raise(LoadError, "no such file to load -- #{english_srt_filename}")

      es_hash = parse_into_hash(File.read(spanish_srt_filename), language: 'es')
      en_hash = parse_into_hash(File.read(english_srt_filename), language: 'en')
    end

    def parse_into_hash(filecontent, language:)
      raise(ArgumentError, "language: keyword param only accepts either 'es' or 'en'") unless %w(es en).include?(language)

      utf8_filecontent = transcode_to_utf8(filecontent)


      h = {}
      utf8_filecontent.each_line("\n\n") do |paragraph|
        # "346\r\n00:39:29,491 --> 00:39:32,559\nThat was \n a long time ago.\n\n"
        paragraph_id, timecode_and_span, *text = paragraph.split("\n")
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

    private

    def transcode_to_utf8(filecontent)
      detection = CharlockHolmes::EncodingDetector.detect(filecontent)
      content_transcoded = CharlockHolmes::Converter.convert filecontent, detection[:encoding], 'UTF-8'
      content_transcoded.encode(universal_newline: true) # to have consistent newline format for parsing by paragraph
    end

  end
end
