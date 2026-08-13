# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.suggested_products(["a","b","c"], "abcde") : (respond_to?(:suggested_products) ? send(:suggested_products, ["a","b","c"], "abcde") : nil)