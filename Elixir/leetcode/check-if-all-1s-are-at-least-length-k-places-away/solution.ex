defmodule Solution do
  @spec k_length_apart(nums :: [integer], k :: integer) :: boolean
  def k_length_apart(nums, k) do
    nums
    |> Enum.with_index()
    |> Enum.reduce_while(-1, fn {v, i}, prev ->
      if v == 1 do
        if prev != -1 and i - prev - 1 < k do
          {:halt, false}
        else
          {:cont, i}
        end
      else
        {:cont, prev}
      end
    end)
    |> case do
      false -> false
      _ -> true
    end
  end
end
