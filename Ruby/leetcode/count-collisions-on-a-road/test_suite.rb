# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.count_collisions("abcde") : (respond_to?(:count_collisions) ? send(:count_collisions, "abcde") : nil)