defmodule Solution do
  @spec is_cousins(root :: TreeNode.t | nil, x :: integer, y :: integer) :: boolean
  def is_cousins(root, x, y) do
    {dx, px, dy, py} = dfs(root, nil, 0, x, y, {-1, nil, -1, nil})
    dx == dy and px != py
  end

  # Parent is tracked by the parent node's value (node values are unique), with
  # nil for the root's parent. A single DFS records depth + parent for x and y.
  defp dfs(nil, _parent, _depth, _x, _y, acc), do: acc

  defp dfs(%TreeNode{val: v, left: l, right: r}, parent, depth, x, y, {dx, px, dy, py}) do
    {dx, px} = if v == x, do: {depth, parent}, else: {dx, px}
    {dy, py} = if v == y, do: {depth, parent}, else: {dy, py}
    acc = {dx, px, dy, py}
    acc = dfs(l, v, depth + 1, x, y, acc)
    dfs(r, v, depth + 1, x, y, acc)
  end
end
