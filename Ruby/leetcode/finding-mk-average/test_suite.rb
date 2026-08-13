# LC-energy test suite (Ruby) — finding-mk-average.
require_relative 'solution'
obj = MKAverage.new(5, 1)
[1,2,3,4,5,6,7,8,9,10].each { |v| obj.add_element(v) }
r = obj.calculate_mk_average
puts r if r < -1
