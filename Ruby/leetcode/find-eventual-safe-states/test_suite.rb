# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.eventual_safe_nodes([1,2,3,4,5]) : (respond_to?(:eventual_safe_nodes) ? send(:eventual_safe_nodes, [1,2,3,4,5]) : nil)