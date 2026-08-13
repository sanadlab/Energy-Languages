# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.is_match("abcde", "abcde") : (respond_to?(:is_match) ? send(:is_match, "abcde", "abcde") : nil)