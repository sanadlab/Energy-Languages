# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.di_string_match("abcde") : (respond_to?(:di_string_match) ? send(:di_string_match, "abcde") : nil)