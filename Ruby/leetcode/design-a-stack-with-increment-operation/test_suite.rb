# LC-energy test suite (Ruby) — design-a-stack-with-increment-operation.
require_relative 'solution'
s = CustomStack.new(5)
[1, 2, 3].each { |v| s.push(v) }
s.increment(2, 100)
r1 = s.pop
r2 = s.pop
puts "unexpected" if r1 < 0 && r2 < 0
