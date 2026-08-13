# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.get_coprimes([1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:get_coprimes) ? send(:get_coprimes, [1,2,3,4,5], [1,2,3,4,5]) : nil)