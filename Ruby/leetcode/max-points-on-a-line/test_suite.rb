# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_points([1,2,3,4,5]) : (respond_to?(:max_points) ? send(:max_points, [1,2,3,4,5]) : nil)