# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.sort_by_bits([1,2,3,4,5]) : (respond_to?(:sort_by_bits) ? send(:sort_by_bits, [1,2,3,4,5]) : nil)