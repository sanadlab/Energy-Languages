# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_sessions([1,2,3,4,5], 20) : (respond_to?(:min_sessions) ? send(:min_sessions, [1,2,3,4,5], 20) : nil)