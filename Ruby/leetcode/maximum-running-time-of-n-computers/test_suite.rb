# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_run_time(20, [1,2,3,4,5]) : (respond_to?(:max_run_time) ? send(:max_run_time, 20, [1,2,3,4,5]) : nil)