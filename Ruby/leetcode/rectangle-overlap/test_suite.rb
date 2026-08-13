# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.is_rectangle_overlap([1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:is_rectangle_overlap) ? send(:is_rectangle_overlap, [1,2,3,4,5], [1,2,3,4,5]) : nil)