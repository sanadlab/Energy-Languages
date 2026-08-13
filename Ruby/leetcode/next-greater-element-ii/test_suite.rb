# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.next_greater_elements([1,2,3,4,5]) : (respond_to?(:next_greater_elements) ? send(:next_greater_elements, [1,2,3,4,5]) : nil)