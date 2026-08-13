# LC-energy test suite (Ruby) — middle-of-the-linked-list.
class ListNode
    attr_accessor :val, :next
    def initialize(val, next_=nil); @val = val; @next = next_; end
end
require_relative 'solution'

h = ListNode.new(1); c = h
[2,3,4,5].each { |v| c.next = ListNode.new(v); c = c.next }
r = middle_node(h)
puts "null" if r.nil?
