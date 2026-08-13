# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_steps(20) : (respond_to?(:min_steps) ? send(:min_steps, 20) : nil)