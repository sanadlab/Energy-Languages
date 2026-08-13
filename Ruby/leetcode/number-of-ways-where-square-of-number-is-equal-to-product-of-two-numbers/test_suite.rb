# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.num_triplets([1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:num_triplets) ? send(:num_triplets, [1,2,3,4,5], [1,2,3,4,5]) : nil)