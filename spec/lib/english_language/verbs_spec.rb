require 'spec_helper'
require_relative '../../../lib/english_language/verbs'
require 'pp'

describe ENGLISH_LANGUAGE::Verbs do
  subject { described_class }

  describe "#new" do
    context "when is initialized" do
      let(:verbs_instance) { described_class.new() }
      it "it defaults to the verbs filename" do
        expect(verbs_instance.verb_list_filename).to end_with(
                                                               "word_lists/wordnet/verb.txt")
      end
    end
  end

  describe "#is_a_verb?" do
    subject { described_class.new() }

    it { expect(subject.is_a_verb?("run")).to be true }
    it { expect(subject.is_a_verb?("hello")).to be false }
  end

  describe "#expand" do
    subject { described_class.new() }

    it "returns nil when the word is not a verb" do
      expect(subject.expand("hello")).to be nil
    end

    it "returns the regular expansion" do
      expect(subject.expand("live")).to eq("live (v)\nlived (v past)\nlived (v participle)\n")
      expect(subject.expand("jump")).to eq("jump (v)\njumped (v past)\njumped (v participle)\n")
    end

    it "returns the irregular expansion" do
      expect(subject.expand("laugh")).to eq(
"laugh (v)
laughed (v past)
laught (v past)
low (v past)
laughed (v participle)
laught (v participle)
laughen (v participle)
")

    end
  end
end
