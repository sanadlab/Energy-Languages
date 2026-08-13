# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_days(20) : (respond_to?(:min_days) ? send(:min_days, 20) : nil)