module SRT
  class Parser
    class << self
      def timecode_string_to_ms(timecode_string)
        timecode = timecode_string.match(/(?<h>\d+):(?<m>\d+):(?<s>\d+)[,.]?(?<ms>\d+)?/)
        minutes = timecode['h'].to_i * 60 +  timecode['m'].to_i
        seconds = minutes * 60 + timecode['s'].to_i
        seconds * 1000 + timecode['ms'].to_i
      end
    end

  end
end