# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_area_rect([1,2,3,4,5]) : (respond_to?(:min_area_rect) ? send(:min_area_rect, [1,2,3,4,5]) : nil)