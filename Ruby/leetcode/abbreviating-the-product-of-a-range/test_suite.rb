# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.abbreviate_product(20, 20) : (respond_to?(:abbreviate_product) ? send(:abbreviate_product, 20, 20) : nil)