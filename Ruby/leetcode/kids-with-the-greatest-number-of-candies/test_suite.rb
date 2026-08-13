# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.kids_with_candies([1,2,3,4,5], 20) : (respond_to?(:kids_with_candies) ? send(:kids_with_candies, [1,2,3,4,5], 20) : nil)