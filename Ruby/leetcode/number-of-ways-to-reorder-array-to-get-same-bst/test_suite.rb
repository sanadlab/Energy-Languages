# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.num_of_ways([1,2,3,4,5]) : (respond_to?(:num_of_ways) ? send(:num_of_ways, [1,2,3,4,5]) : nil)