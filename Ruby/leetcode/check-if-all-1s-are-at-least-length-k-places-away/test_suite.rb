# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.k_length_apart([1,2,3,4,5], 20) : (respond_to?(:k_length_apart) ? send(:k_length_apart, [1,2,3,4,5], 20) : nil)