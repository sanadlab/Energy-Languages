# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.maximum_beauty([1,2,3,4,5], 20, 20, 20, 20) : (respond_to?(:maximum_beauty) ? send(:maximum_beauty, [1,2,3,4,5], 20, 20, 20, 20) : nil)