defmodule Solution do
  @spec min_depth(root :: TreeNode.t | nil) :: integer
  def min_depth(nil), do: 0
  def min_depth(root), do: bfs([root], 1)

  # Level-order BFS: the first level that contains a leaf gives the minimum
  # depth, so the search stops there instead of visiting the whole tree.
  defp bfs(level, depth) do
    if Enum.any?(level, fn %TreeNode{left: l, right: r} -> is_nil(l) and is_nil(r) end) do
      depth
    else
      next =
        Enum.flat_map(level, fn %TreeNode{left: l, right: r} ->
          Enum.reject([l, r], &is_nil/1)
        end)

      bfs(next, depth + 1)
    end
  end
end
