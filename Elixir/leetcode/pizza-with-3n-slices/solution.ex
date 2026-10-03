defmodule Solution do
  @spec max_size_slices(slices :: [integer]) :: integer
  def max_size_slices(slices) do
    total = length(slices)
    k = div(total, 3)

    if k == 0 do
      0
    else
      max(best(Enum.drop(slices, -1), k), best(tl(slices), k))
    end
  end

  # Maximum sum of k non-adjacent elements in a line.
  defp best(nums, k) do
    neg = -1_000_000_000
    n = length(nums)
    nums_t = List.to_tuple(nums)
    row0 = List.to_tuple([0 | List.duplicate(neg, k)])

    {final, _prev2} =
      Enum.reduce(1..n, {row0, row0}, fn i, {prev, prev2} ->
        val_i = elem(nums_t, i - 1)

        new_row =
          Enum.map(0..k, fn j ->
            if j == 0 do
              0
            else
              skip = elem(prev, j)

              prevv =
                if i >= 2 do
                  elem(prev2, j - 1)
                else
                  if j == 1, do: 0, else: neg
                end

              max(skip, prevv + val_i)
            end
          end)
          |> List.to_tuple()

        {new_row, prev}
      end)

    elem(final, k)
  end
end
