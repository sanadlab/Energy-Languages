defmodule Solution do
  @spec di_string_match(s :: String.t) :: [integer]
  def di_string_match(s) do
    {perm_rev, low, _high} =
      s
      |> String.to_charlist()
      |> Enum.reduce({[], 0, byte_size(s)}, fn c, {acc, low, high} ->
        if c == ?I do
          {[low | acc], low + 1, high}
        else
          {[high | acc], low, high - 1}
        end
      end)

    Enum.reverse([low | perm_rev])
  end
end
