defmodule Solution do
  @spec min_steps(n :: integer) :: integer
  def min_steps(n) do
    factor_sum(n, 2, 0)
  end

  defp factor_sum(n, _d, res) when n <= 1, do: res
  defp factor_sum(n, d, res) do
    if rem(n, d) == 0 do
      factor_sum(div(n, d), d, res + d)
    else
      factor_sum(n, d + 1, res)
    end
  end
end
