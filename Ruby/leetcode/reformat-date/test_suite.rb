# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.reformat_date("abcde") : (respond_to?(:reformat_date) ? send(:reformat_date, "abcde") : nil)