defmodule Solution do
  @spec min_days(n :: integer) :: integer
  def min_days(n) do
    {r, _} = solve(n, %{})
    r
  end

  defp solve(x, memo) when x <= 1, do: {x, memo}

  defp solve(x, memo) do
    case Map.get(memo, x) do
      nil ->
        {a, m1} = solve(div(x, 2), memo)
        {b, m2} = solve(div(x, 3), m1)
        res = 1 + min(rem(x, 2) + a, rem(x, 3) + b)
        {res, Map.put(m2, x, res)}

      v ->
        {v, memo}
    end
  end
end
