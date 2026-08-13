# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_compatibility_sum([1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:max_compatibility_sum) ? send(:max_compatibility_sum, [1,2,3,4,5], [1,2,3,4,5]) : nil)