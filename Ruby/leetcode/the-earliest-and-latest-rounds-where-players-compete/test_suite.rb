# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.earliest_and_latest(20, 20, 20) : (respond_to?(:earliest_and_latest) ? send(:earliest_and_latest, 20, 20, 20) : nil)