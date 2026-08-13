# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.max_students([["a","b"],["c","d"]]) : (respond_to?(:max_students) ? send(:max_students, [["a","b"],["c","d"]]) : nil)