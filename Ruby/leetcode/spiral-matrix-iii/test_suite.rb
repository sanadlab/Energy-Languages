# LC-energy test suite (Ruby) — hardcoded single case.
require_relative 'solution'
_lc = defined?(Solution) ? Solution.new.spiral_matrix_iii(20, 20, 20, 20) : (respond_to?(:spiral_matrix_iii) ? send(:spiral_matrix_iii, 20, 20, 20, 20) : nil)