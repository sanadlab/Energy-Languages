# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.close_strings("abcde", "abcde") : (respond_to?(:close_strings) ? send(:close_strings, "abcde", "abcde") : nil)