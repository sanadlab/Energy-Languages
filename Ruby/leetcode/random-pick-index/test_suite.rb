# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new([1, 2, 3, 4, 5]).pick(3) : nil
