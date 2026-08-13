# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.is_sum_equal("abcde", "abcde", "abcde") : (respond_to?(:is_sum_equal) ? send(:is_sum_equal, "abcde", "abcde", "abcde") : nil)