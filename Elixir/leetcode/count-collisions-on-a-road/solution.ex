defmodule Solution do
  @spec count_collisions(directions :: String.t) :: integer
  def count_collisions(directions) do
    chars = String.to_charlist(directions)
    # Leading 'L' cars drive off to the left and never collide.
    after_left = Enum.drop_while(chars, &(&1 == ?L))
    # Trailing 'R' cars drive off to the right and never collide.
    middle =
      after_left
      |> Enum.reverse()
      |> Enum.drop_while(&(&1 == ?R))
      |> Enum.reverse()

    # Every remaining moving car ('L' or 'R') collides and adds 1.
    Enum.count(middle, &(&1 != ?S))
  end
end
