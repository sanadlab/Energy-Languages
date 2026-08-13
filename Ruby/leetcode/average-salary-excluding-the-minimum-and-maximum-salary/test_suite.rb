# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.average([1,2,3,4,5]) : (respond_to?(:average) ? send(:average, [1,2,3,4,5]) : nil)