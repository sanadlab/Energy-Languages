# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.ambiguous_coordinates("abcde") : (respond_to?(:ambiguous_coordinates) ? send(:ambiguous_coordinates, "abcde") : nil)