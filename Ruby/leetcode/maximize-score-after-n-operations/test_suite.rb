# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_score([1,2,3,4,5]) : (respond_to?(:max_score) ? send(:max_score, [1,2,3,4,5]) : nil)