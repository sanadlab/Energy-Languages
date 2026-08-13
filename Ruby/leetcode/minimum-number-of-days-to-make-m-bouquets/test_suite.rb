# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_days([1,2,3,4,5], 20, 20) : (respond_to?(:min_days) ? send(:min_days, [1,2,3,4,5], 20, 20) : nil)