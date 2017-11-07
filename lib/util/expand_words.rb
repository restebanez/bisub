module UTIL
  class ExpandWords
    attr_reader :file_path

    def initialize(file_path)
      File.file?(file_path) || raise(LoadError, "no such file to load -- #{file_path}")
      @file_path = file_path
    end

  end
end
