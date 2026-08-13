# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.is_scramble("abcde", "abcde") : (respond_to?(:is_scramble) ? send(:is_scramble, "abcde", "abcde") : nil)