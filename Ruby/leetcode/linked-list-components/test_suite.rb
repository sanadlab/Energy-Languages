# LC-energy test suite (Ruby) — linked-list-components.
require 'set'

class ListNode
    attr_accessor :val, :next
    def initialize(val, next_=nil); @val = val; @next = next_; end
end
require_relative 'solution'

h = ListNode.new(0); h.next = ListNode.new(1); h.next.next = ListNode.new(2); h.next.next.next = ListNode.new(3)
r = num_components(h, [0, 1, 3])
puts r if r < 0
