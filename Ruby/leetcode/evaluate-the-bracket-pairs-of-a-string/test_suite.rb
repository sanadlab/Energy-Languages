# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.evaluate("abcde", [["a","b"],["c","d"]]) : (respond_to?(:evaluate) ? send(:evaluate, "abcde", [["a","b"],["c","d"]]) : nil)