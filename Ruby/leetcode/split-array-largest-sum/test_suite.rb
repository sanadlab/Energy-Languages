# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.split_array([1,2,3,4,5], 20) : (respond_to?(:split_array) ? send(:split_array, [1,2,3,4,5], 20) : nil)