# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.next_beautiful_number(20) : (respond_to?(:next_beautiful_number) ? send(:next_beautiful_number, 20) : nil)