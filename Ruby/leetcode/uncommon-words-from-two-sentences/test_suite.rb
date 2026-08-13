# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.uncommon_from_sentences("abcde", "abcde") : (respond_to?(:uncommon_from_sentences) ? send(:uncommon_from_sentences, "abcde", "abcde") : nil)