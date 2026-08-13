# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.restore_array([1,2,3,4,5]) : (respond_to?(:restore_array) ? send(:restore_array, [1,2,3,4,5]) : nil)