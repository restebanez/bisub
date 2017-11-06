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

  context 'when valid files are passed' do
    let(:filecontent_ISO_8859_1) { "2\r\n00:00:03,357 --> 00:00:06,558\r\nY en este d\xEDa, comenzamos\r\na reorganizar este mundo.\r\n\r\n3\r\n00:00:10,297 --> 00:00:13,665\r\nTodos podr\xE1n vivir si\r\nse rinden ahora mismo.\r\n\r\n"}
    let(:filecontent_UTF_8) {      "2\n00:00:03,357 --> 00:00:06,558\nY en este día, comenzamos\na reorganizar este mundo.\n\n3\n00:00:10,297 --> 00:00:13,665\nTodos podrán vivir si\nse rinden ahora mismo.\n\n"}
    let(:srt_load_instance) { described_class.new(spanish_srt_filename: SPANISH_SRT_FILENAME,
                                                  english_srt_filename: ENGLISH_SRT_FILENAME) }

    describe "#transcode_to_utf8" do
      it "transform a non UTF-8 to UTF-8 and univeral newline" do
        expect(srt_load_instance.send(:transcode_to_utf8, filecontent_ISO_8859_1)).to eq(filecontent_UTF_8)
      end
    end

    describe "#parse_into_hash" do
      it "generates a UTF-8 hash of hashes where every value is from a string paragraph" do
        expect(srt_load_instance.parse_into_hash(filecontent_ISO_8859_1, language: 'es')).to eq({
            3357 => {:timecode=>"00:00:03,357", :timespan=>"00:00:06,558", :paragraph_id_es=>2, :text_es=>["Y en este día, comenzamos", "a reorganizar este mundo."]},
           10297 => {:timecode=>"00:00:10,297", :timespan=>"00:00:13,665", :paragraph_id_es=>3, :text_es=>["Todos podrán vivir si", "se rinden ahora mismo."]}

        })
      end

      it "raises when language keword is neither 'es' nor 'en'" do
        expect { srt_load_instance.parse_into_hash(filecontent_ISO_8859_1, language: 'fr') }.to raise_exception(ArgumentError)
      end
    end

    describe ".combine" do
      it "generates a merged hash with both subtitles" do
          expect(described_class.combine(spanish_srt_filename: SPANISH_SRT_FILENAME,
                                         english_srt_filename: ENGLISH_SRT_FILENAME)[0]).to eq(
             {
                 :paragraph_id_en => 1,
                 :paragraph_id_es => 1,
                 :text_en => ["<i>Previously on AMC's", "\"The Walking Dead\"...</i>"],
                 :text_es => ["Anteriormente en The Walking Dead..."],
                 :timecode => "00:00:00,453",
                 :timespan => "00:00:03,355"
             })
      end
    end

  end

end
