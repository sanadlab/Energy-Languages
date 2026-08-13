# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.license_key_formatting("abcde", 20) : (respond_to?(:license_key_formatting) ? send(:license_key_formatting, "abcde", 20) : nil)