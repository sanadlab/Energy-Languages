# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.hit_bricks([1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:hit_bricks) ? send(:hit_bricks, [1,2,3,4,5], [1,2,3,4,5]) : nil)