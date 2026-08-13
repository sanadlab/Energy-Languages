# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.check_straight_line([1,2,3,4,5]) : (respond_to?(:check_straight_line) ? send(:check_straight_line, [1,2,3,4,5]) : nil)