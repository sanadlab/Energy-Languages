# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.shuffle([1,2,3,4,5], 20) : (respond_to?(:shuffle) ? send(:shuffle, [1,2,3,4,5], 20) : nil)