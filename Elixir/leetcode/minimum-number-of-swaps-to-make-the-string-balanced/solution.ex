defmodule Solution do
  @spec min_swaps(s :: String.t) :: integer
  def min_swaps(s) do
    open_ =
      s
      |> :binary.bin_to_list()
      |> Enum.reduce(0, fn c, open_ ->
        cond do
          c == ?[ -> open_ + 1
          open_ > 0 -> open_ - 1
          true -> open_
        end
      end)

    div(open_ + 1, 2)
  end
end
