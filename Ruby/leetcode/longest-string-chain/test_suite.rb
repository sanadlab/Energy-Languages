# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.longest_str_chain(["a","b","c"]) : (respond_to?(:longest_str_chain) ? send(:longest_str_chain, ["a","b","c"]) : nil)