# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.num_smaller_by_frequency(["a","b","c"], ["a","b","c"]) : (respond_to?(:num_smaller_by_frequency) ? send(:num_smaller_by_frequency, ["a","b","c"], ["a","b","c"]) : nil)