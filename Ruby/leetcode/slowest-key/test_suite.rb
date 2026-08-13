# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.slowest_key([1,2,3,4,5], "abcde") : (respond_to?(:slowest_key) ? send(:slowest_key, [1,2,3,4,5], "abcde") : nil)