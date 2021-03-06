# given an unverified regular verb, it expands it adding the past and past participle
module ENGLISH_LANGUAGE
  class RegularVerbs
    class << self
      # expand("walk") => "walk (v)\nwalked (v past)\nwalked (v participle)\n"
      def expand(regular_verb)
        raise(ArgumentError, "regular_verb param has to be word") unless regular_verb =~ /[a-z]{2,}/
        suffix = regular_verb.match(/e$/) ? "d" : "ed"
        "#{regular_verb} (v)\n#{regular_verb}#{suffix} (v past)\n#{regular_verb}#{suffix} (v participle)\n"
      end
    end
  end
end
