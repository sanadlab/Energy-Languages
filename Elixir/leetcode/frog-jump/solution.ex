defmodule Solution do
  @spec can_cross(stones :: [integer]) :: boolean
  def can_cross(stones) do
    if length(stones) < 2 or Enum.at(stones, 1) != 1 do
      false
    else
      stone_set = MapSet.new(stones)
      last = List.last(stones)

      dp =
        Enum.reduce(stones, %{1 => MapSet.new([1])}, fn stone, dp ->
          ks = Map.get(dp, stone, MapSet.new())

          Enum.reduce(ks, dp, fn k, dp ->
            Enum.reduce([k - 1, k, k + 1], dp, fn step, dp ->
              nxt = stone + step

              if step > 0 and MapSet.member?(stone_set, nxt) do
                Map.update(dp, nxt, MapSet.new([step]), &MapSet.put(&1, step))
              else
                dp
              end
            end)
          end)
        end)

      MapSet.size(Map.get(dp, last, MapSet.new())) > 0
    end
  end
end
