require 'spec_helper'
require_relative '../../../lib/english_language/regular_verbs'

describe ENGLISH_LANGUAGE::RegularVerbs do
  subject { described_class }

  it "expands the regular verb adding the suffixes ed (past) and ed (paticiple)" do
    expect(subject.expand("walk")).to eq("walk (v)\nwalked (v past)\nwalked (v participle)\n")
  end

  it "raises an exception if the verb seems invalid" do
    expect { subject.expand("") }.to raise_error(ArgumentError)
    expect { subject.expand("8") }.to raise_error(ArgumentError)
    expect { subject.expand("a") }.to raise_error(ArgumentError)
  end

end
