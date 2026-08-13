# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.count_vowel_substrings("abcde") : (respond_to?(:count_vowel_substrings) ? send(:count_vowel_substrings, "abcde") : nil)