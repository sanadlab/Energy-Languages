# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.str_without3a3b(20, 20) : (respond_to?(:str_without3a3b) ? send(:str_without3a3b, 20, 20) : nil)