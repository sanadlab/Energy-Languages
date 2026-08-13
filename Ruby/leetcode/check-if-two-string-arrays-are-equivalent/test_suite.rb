# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.array_strings_are_equal(["a","b","c"], ["a","b","c"]) : (respond_to?(:array_strings_are_equal) ? send(:array_strings_are_equal, ["a","b","c"], ["a","b","c"]) : nil)