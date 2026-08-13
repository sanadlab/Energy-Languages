# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.can_partition_k_subsets([1,2,3,4,5], 20) : (respond_to?(:can_partition_k_subsets) ? send(:can_partition_k_subsets, [1,2,3,4,5], 20) : nil)