defmodule Solution do
  @spec median_sliding_window(nums :: [integer], k :: integer) :: [float]
  def median_sliding_window(nums, k) do
    tup = List.to_tuple(nums)
    n = tuple_size(tup)

    if n - k + 1 <= 0 do
      []
    else
      mid = div(k, 2)

      Enum.map(0..(n - k), fn i ->
        w = Enum.sort(for j <- i..(i + k - 1), do: elem(tup, j))
        wt = List.to_tuple(w)

        if rem(k, 2) == 1 do
          elem(wt, mid) / 1
        else
          (elem(wt, mid - 1) + elem(wt, mid)) / 2
        end
      end)
    end
  end
end
