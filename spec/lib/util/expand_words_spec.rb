require 'spec_helper'
require_relative '../../../lib/util/expand_words'

require 'tempfile'

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

  describe "#perform" do
    before do
      @tmp_file = Tempfile.new('perform')
      @tmp_file.write(
"write
hello
build
pass
orange
")
      @tmp_file.close
    end

    let(:expand_words_instance) { described_class.new(@tmp_file.path) }

    it "expands the words" do
      expect(expand_words_instance.perform).to eq(
"write (v)
wrote (v past)
writ (v past)
written (v participle)
writ (v participle)
hello
build (v)
built (v past)
built (v participle)
pass (v)
passed (v past)
passed (v participle)
orange
")
    end

    after do
      @tmp_file.unlink
    end
  end
end
