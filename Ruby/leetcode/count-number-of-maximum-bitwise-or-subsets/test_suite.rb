# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.count_max_or_subsets([1,2,3,4,5]) : (respond_to?(:count_max_or_subsets) ? send(:count_max_or_subsets, [1,2,3,4,5]) : nil)