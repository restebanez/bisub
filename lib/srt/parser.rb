module SRT
  class ParserError < StandardError; end
  class Parser
    class << self
      def timecode_to_ms(timecode_string)
        if /(?<hours>\d+):(?<minutes>\d+):(?<seconds>\d+)[,.]?(?<miliseconds>\d+)?/ =~ timecode_string
          subtotal_minutes = hours.to_i * 60 +  minutes.to_i
          subtotal_seconds = subtotal_minutes * 60 + seconds.to_i
          subtotal_seconds * 1000 + miliseconds.to_i
        else
          raise ParserError, "Failed to parse this timecode: #{timecode_string}"
        end
      end

    end

  end
end
