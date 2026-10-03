defmodule Solution do
  @spec can_be_typed_words(text :: String.t, broken_letters :: String.t) :: integer
  def can_be_typed_words(text, broken_letters) do
    broken = broken_letters |> String.graphemes() |> MapSet.new()

    text
    |> String.split()
    |> Enum.count(fn word ->
      word
      |> String.graphemes()
      |> Enum.all?(fn ch -> not MapSet.member?(broken, ch) end)
    end)
  end
end
