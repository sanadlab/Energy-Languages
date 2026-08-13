# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.maximum_binary_string("abcde") : (respond_to?(:maximum_binary_string) ? send(:maximum_binary_string, "abcde") : nil)