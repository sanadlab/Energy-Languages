# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.count_triples(20) : (respond_to?(:count_triples) ? send(:count_triples, 20) : nil)