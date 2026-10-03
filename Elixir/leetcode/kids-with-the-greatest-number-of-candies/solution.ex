defmodule Solution do
  @spec kids_with_candies(candies :: [integer], extra_candies :: integer) :: [boolean]
  def kids_with_candies(candies, extra_candies) do
    max_candies = Enum.max(candies)
    Enum.map(candies, fn kid -> kid + extra_candies >= max_candies end)
  end
end
