def is_cousins(root, x, y)
  queue = [root]

  until queue.empty?
    level_size = queue.length
    x_parent = nil
    y_parent = nil

    level_size.times do
      node = queue.shift

      if node.left
        x_parent = node if node.left.val == x
        y_parent = node if node.left.val == y
        queue << node.left
      end

      if node.right
        x_parent = node if node.right.val == x
        y_parent = node if node.right.val == y
        queue << node.right
      end
    end

    return x_parent != y_parent if x_parent && y_parent
    return false if x_parent || y_parent
  end

  false
end