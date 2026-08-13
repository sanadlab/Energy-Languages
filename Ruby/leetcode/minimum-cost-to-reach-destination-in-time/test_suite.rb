# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_cost(20, [1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:min_cost) ? send(:min_cost, 20, [1,2,3,4,5], [1,2,3,4,5]) : nil)