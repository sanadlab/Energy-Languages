# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.count_good_rectangles([1,2,3,4,5]) : (respond_to?(:count_good_rectangles) ? send(:count_good_rectangles, [1,2,3,4,5]) : nil)