# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.can_cross([1,2,3,4,5]) : (respond_to?(:can_cross) ? send(:can_cross, [1,2,3,4,5]) : nil)