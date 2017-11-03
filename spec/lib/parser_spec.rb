require 'spec_helper'
require_relative '../../lib/srt/parser'

describe SRT::Parser do
  subject { described_class }

  describe ".timecode_string_to_ms" do
    it "converts the SRT timecode string format to an integer representing ms" do
      expect(subject.timecode_to_ms("01:03:44,200")).to eq(3824200)
    end

    it "milisecods is an optional piece of data" do
      expect(subject.timecode_to_ms("01:03:44")).to eq(3824000)
    end

    it "raises an exception when the SRT timecode string format isn't valid" do
      expect { subject.timecode_to_ms("01:0344,200") }.to raise_error(SRT::ParserError)
    end

    it "raises an exception when the SRT timecode is empty" do
      expect { subject.timecode_to_ms("") }.to raise_error(SRT::ParserError)
    end
  end
end
