# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.validate_binary_tree_nodes(20, [1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:validate_binary_tree_nodes) ? send(:validate_binary_tree_nodes, 20, [1,2,3,4,5], [1,2,3,4,5]) : nil)