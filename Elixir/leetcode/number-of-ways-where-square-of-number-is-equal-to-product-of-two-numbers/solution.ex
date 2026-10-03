defmodule Solution do
  @spec num_triplets(nums1 :: [integer], nums2 :: [integer]) :: integer
  def num_triplets(nums1, nums2) do
    helper(nums1, nums2) + helper(nums2, nums1)
  end

  defp helper(a, b) do
    Enum.reduce(a, 0, fn x, cnt ->
      t = x * x

      {cnt, _seen} =
        Enum.reduce(b, {cnt, %{}}, fn y, {c, seen} ->
          c =
            if rem(t, y) == 0 do
              need = div(t, y)
              c + Map.get(seen, need, 0)
            else
              c
            end

          {c, Map.update(seen, y, 1, &(&1 + 1))}
        end)

      cnt
    end)
  end
end
