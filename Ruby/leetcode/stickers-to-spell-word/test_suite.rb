# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_stickers(["a","b","c"], "abcde") : (respond_to?(:min_stickers) ? send(:min_stickers, ["a","b","c"], "abcde") : nil)