# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.days_between_dates("abcde", "abcde") : (respond_to?(:days_between_dates) ? send(:days_between_dates, "abcde", "abcde") : nil)