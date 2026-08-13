# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_total_fruits([1,2,3,4,5], 20, 20) : (respond_to?(:max_total_fruits) ? send(:max_total_fruits, [1,2,3,4,5], 20, 20) : nil)