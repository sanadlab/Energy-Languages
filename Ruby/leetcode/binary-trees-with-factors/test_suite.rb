# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.num_factored_binary_trees([1,2,3,4,5]) : (respond_to?(:num_factored_binary_trees) ? send(:num_factored_binary_trees, [1,2,3,4,5]) : nil)