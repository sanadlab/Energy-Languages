defmodule Solution do
  @spec abbreviate_product(left :: integer, right :: integer) :: String.t
  def abbreviate_product(left, right) do
    p = Enum.reduce(left..right//1, 1, fn i, acc -> acc * i end)
    {p, c} = strip_zeros(p, 0)
    s = Integer.to_string(p)

    if String.length(s) <= 10 do
      "#{s}e#{c}"
    else
      "#{String.slice(s, 0, 5)}...#{String.slice(s, -5, 5)}e#{c}"
    end
  end

  defp strip_zeros(p, c) do
    if p != 0 and rem(p, 10) == 0 do
      strip_zeros(div(p, 10), c + 1)
    else
      {p, c}
    end
  end
end
