# LC-energy test suite (Ruby) — cousins-in-binary-tree.
class TreeNode
    attr_accessor :val, :left, :right
    def initialize(val, left=nil, right=nil); @val = val; @left = left; @right = right; end
end
require_relative 'solution'

root = TreeNode.new(1)
root.left  = TreeNode.new(2); root.left.right  = TreeNode.new(4)
root.right = TreeNode.new(3); root.right.right = TreeNode.new(5)
r = is_cousins(root, 4, 5)
puts "unexpected" unless r
