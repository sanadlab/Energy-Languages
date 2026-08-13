# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.median_sliding_window([1,2,3,4,5], 20) : (respond_to?(:median_sliding_window) ? send(:median_sliding_window, [1,2,3,4,5], 20) : nil)