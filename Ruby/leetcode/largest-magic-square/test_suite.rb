# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.largest_magic_square([1,2,3,4,5]) : (respond_to?(:largest_magic_square) ? send(:largest_magic_square, [1,2,3,4,5]) : nil)