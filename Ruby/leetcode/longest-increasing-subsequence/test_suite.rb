# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.length_of_lis([1,2,3,4,5]) : (respond_to?(:length_of_lis) ? send(:length_of_lis, [1,2,3,4,5]) : nil)