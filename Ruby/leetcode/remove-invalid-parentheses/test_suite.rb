# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.remove_invalid_parentheses("abcde") : (respond_to?(:remove_invalid_parentheses) ? send(:remove_invalid_parentheses, "abcde") : nil)