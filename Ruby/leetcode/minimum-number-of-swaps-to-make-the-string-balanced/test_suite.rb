# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_swaps("abcde") : (respond_to?(:min_swaps) ? send(:min_swaps, "abcde") : nil)