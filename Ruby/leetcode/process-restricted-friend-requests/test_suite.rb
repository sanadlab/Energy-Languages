# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.friend_requests(20, [1,2,3,4,5], [1,2,3,4,5]) : (respond_to?(:friend_requests) ? send(:friend_requests, 20, [1,2,3,4,5], [1,2,3,4,5]) : nil)