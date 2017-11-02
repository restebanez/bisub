require 'spec_helper'
require_relative '../../lib/srt/load'

SPANISH_SRT_FILENAME = 'srt_examples/sync/The.Walking.Dead.S08E02.HDTV.x264-SVA[rarbg]/The.Walking.Dead.S08E02.HDTV.x264-SVA.es.srt'
ENGLISH_SRT_FILENAME = 'srt_examples/sync/The.Walking.Dead.S08E02.HDTV.x264-SVA[rarbg]/The.Walking.Dead.S08E02.HDTV.x264-SVA.en.srt'

describe SRT::Load do
  subject { described_class }

  describe "#new" do
    it "accepts two existing filename paths" do
      expect(described_class.new(spanish_srt_filename: SPANISH_SRT_FILENAME,
                                 english_srt_filename: ENGLISH_SRT_FILENAME)).to be_truthy
    end

    it "raises when at least one of the files don't exists" do
      expect {described_class.new(spanish_srt_filename: './non-existing-file',
                                  english_srt_filename: ENGLISH_SRT_FILENAME) }.to raise_exception(LoadError)
    end
  end
end