# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_operations("abcde") : (respond_to?(:min_operations) ? send(:min_operations, "abcde") : nil)