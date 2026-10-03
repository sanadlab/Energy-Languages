defmodule Solution do
  @spec is_rectangle_overlap(rec1 :: [integer], rec2 :: [integer]) :: boolean
  def is_rectangle_overlap(rec1, rec2) do
    [a0, a1, a2, a3] = rec1
    [b0, b1, b2, b3] = rec2
    a0 < b2 and b0 < a2 and a1 < b3 and b1 < a3
  end
end
