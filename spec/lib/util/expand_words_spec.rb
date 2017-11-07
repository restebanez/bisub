require 'spec_helper'
require_relative '../../../lib/util/expand_words'

describe UTIL::ExpandWords do
  subject { described_class }
  let(:most_common_words_path){ File.expand_path('../../../word_lists/basic_english/200_most_common_words.txt',__dir__)}

  describe "#new" do
    it "requires a valid file path" do
      expect(described_class.new(most_common_words_path)).to be_truthy
    end

    it "raises an error if the given file path doesn't exist" do
      expect { described_class.new('invalid-path') }.to raise_error(LoadError)
    end
  end
end
