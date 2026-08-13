# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_size_slices([1,2,3,4,5]) : (respond_to?(:max_size_slices) ? send(:max_size_slices, [1,2,3,4,5]) : nil)