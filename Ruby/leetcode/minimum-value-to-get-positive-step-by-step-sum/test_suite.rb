# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_start_value([1,2,3,4,5]) : (respond_to?(:min_start_value) ? send(:min_start_value, [1,2,3,4,5]) : nil)