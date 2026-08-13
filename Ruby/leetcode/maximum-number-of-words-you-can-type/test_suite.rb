# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.can_be_typed_words("abcde", "abcde") : (respond_to?(:can_be_typed_words) ? send(:can_be_typed_words, "abcde", "abcde") : nil)