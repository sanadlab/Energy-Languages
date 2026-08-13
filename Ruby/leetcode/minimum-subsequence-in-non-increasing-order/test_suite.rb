# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.min_subsequence([1,2,3,4,5]) : (respond_to?(:min_subsequence) ? send(:min_subsequence, [1,2,3,4,5]) : nil)