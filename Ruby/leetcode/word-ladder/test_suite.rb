# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.ladder_length("abcde", "abcde", ["a","b","c"]) : (respond_to?(:ladder_length) ? send(:ladder_length, "abcde", "abcde", ["a","b","c"]) : nil)