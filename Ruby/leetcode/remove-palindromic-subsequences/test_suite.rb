# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.remove_palindrome_sub("abcde") : (respond_to?(:remove_palindrome_sub) ? send(:remove_palindrome_sub, "abcde") : nil)