# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.judge_circle("abcde") : (respond_to?(:judge_circle) ? send(:judge_circle, "abcde") : nil)