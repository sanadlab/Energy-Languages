# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.regions_by_slashes(["a","b","c"]) : (respond_to?(:regions_by_slashes) ? send(:regions_by_slashes, ["a","b","c"]) : nil)