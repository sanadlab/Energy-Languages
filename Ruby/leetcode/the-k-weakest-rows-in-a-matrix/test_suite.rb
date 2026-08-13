# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.k_weakest_rows([1,2,3,4,5], 20) : (respond_to?(:k_weakest_rows) ? send(:k_weakest_rows, [1,2,3,4,5], 20) : nil)