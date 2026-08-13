# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.is_solvable(["a","b","c"], "abcde") : (respond_to?(:is_solvable) ? send(:is_solvable, ["a","b","c"], "abcde") : nil)