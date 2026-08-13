# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.maximum_and_sum([1,2,3,4,5], 20) : (respond_to?(:maximum_and_sum) ? send(:maximum_and_sum, [1,2,3,4,5], 20) : nil)