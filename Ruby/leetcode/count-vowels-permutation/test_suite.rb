# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.count_vowel_permutation(20) : (respond_to?(:count_vowel_permutation) ? send(:count_vowel_permutation, 20) : nil)