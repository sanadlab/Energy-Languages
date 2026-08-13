def min_depth(root)
    return 0 if root.nil?
    queue = [root]
    depth = 1
    until queue.empty?
        next_level = []
        queue.each do |node|
            return depth if node.left.nil? && node.right.nil?
            next_level << node.left unless node.left.nil?
            next_level << node.right unless node.right.nil?
        end
        queue = next_level
        depth += 1
    end
    depth
end
