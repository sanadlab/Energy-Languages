# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.find_k_distant_indices([1,2,3,4,5], 20, 20) : (respond_to?(:find_k_distant_indices) ? send(:find_k_distant_indices, [1,2,3,4,5], 20, 20) : nil)