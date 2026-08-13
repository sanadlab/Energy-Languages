# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.xor_operation(20, 20) : (respond_to?(:xor_operation) ? send(:xor_operation, 20, 20) : nil)