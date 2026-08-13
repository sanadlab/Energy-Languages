# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.clumsy(20) : (respond_to?(:clumsy) ? send(:clumsy, 20) : nil)