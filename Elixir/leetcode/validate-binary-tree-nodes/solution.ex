defmodule Solution do
  @spec validate_binary_tree_nodes(n :: integer, left_child :: [integer], right_child :: [integer]) :: boolean
  def validate_binary_tree_nodes(n, left_child, right_child) do
    m = min(length(left_child), length(right_child))
    lt = List.to_tuple(left_child)
    rt = List.to_tuple(right_child)

    case build_indeg(m, n, lt, rt) do
      :invalid ->
        false

      indeg ->
        case find_root(n, indeg) do
          -1 -> false
          root -> dfs_ok?(root, n, m, lt, rt)
        end
    end
  end

  defp build_indeg(0, _n, _lt, _rt), do: %{}

  defp build_indeg(m, n, lt, rt) do
    Enum.reduce_while(0..(m - 1), %{}, fn i, indeg ->
      case add_two(elem(lt, i), elem(rt, i), n, indeg) do
        :invalid -> {:halt, :invalid}
        new_indeg -> {:cont, new_indeg}
      end
    end)
  end

  defp add_two(l, r, n, indeg) do
    case add_one(l, n, indeg) do
      :invalid -> :invalid
      indeg1 -> add_one(r, n, indeg1)
    end
  end

  defp add_one(-1, _n, indeg), do: indeg

  defp add_one(c, n, indeg) do
    if c < 0 or c >= n do
      :invalid
    else
      d = Map.get(indeg, c, 0) + 1
      if d > 1, do: :invalid, else: Map.put(indeg, c, d)
    end
  end

  defp find_root(n, indeg) do
    Enum.reduce_while(0..(n - 1), -1, fn i, root ->
      if Map.get(indeg, i, 0) == 0 do
        if root != -1, do: {:halt, -1}, else: {:cont, i}
      else
        {:cont, root}
      end
    end)
  end

  defp dfs_ok?(root, n, m, lt, rt) do
    dfs_loop([root], MapSet.new(), 0, n, m, lt, rt)
  end

  defp dfs_loop([], _visited, count, n, _m, _lt, _rt), do: count == n

  defp dfs_loop([node | stack], visited, count, n, m, lt, rt) do
    if MapSet.member?(visited, node) do
      false
    else
      visited = MapSet.put(visited, node)

      stack =
        if node < m do
          cons_child(elem(rt, node), cons_child(elem(lt, node), stack))
        else
          stack
        end

      dfs_loop(stack, visited, count + 1, n, m, lt, rt)
    end
  end

  defp cons_child(-1, stack), do: stack
  defp cons_child(c, stack), do: [c | stack]
end
