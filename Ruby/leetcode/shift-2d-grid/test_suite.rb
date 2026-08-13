# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.shift_grid([1,2,3,4,5], 20) : (respond_to?(:shift_grid) ? send(:shift_grid, [1,2,3,4,5], 20) : nil)