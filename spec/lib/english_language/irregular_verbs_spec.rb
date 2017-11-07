require 'spec_helper'
require_relative '../../../lib/english_language/irregular_verbs'

describe ENGLISH_LANGUAGE::IrregularVerbs do
  subject { described_class }

  describe "#new" do
    context "when is initialized" do
      let(:irregular_verbs_instance) { described_class.new() }
      it "it defaults to the irregular verbs filename" do
        expect(irregular_verbs_instance.file_word_list).to end_with(
           "word_lists/basic_english/irregular_verbs.txt")
      end

      describe "#parse" do
        subject { irregular_verbs_instance.parse }

        it { is_expected.to be_an(Array) }
        it { is_expected.to all( be_a(Array)) }
        it { is_expected.to include(["ake", ["oke"], ["aken"]]) }
        it { is_expected.to include(["bless", ["blessed","blest"], ["blessed","blest"]]) }
      end
    end
  end
end
