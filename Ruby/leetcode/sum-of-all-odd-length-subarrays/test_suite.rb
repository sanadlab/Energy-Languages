# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.sum_odd_length_subarrays([1,2,3,4,5]) : (respond_to?(:sum_odd_length_subarrays) ? send(:sum_odd_length_subarrays, [1,2,3,4,5]) : nil)