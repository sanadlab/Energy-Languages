# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.are_occurrences_equal("abcde") : (respond_to?(:are_occurrences_equal) ? send(:are_occurrences_equal, "abcde") : nil)