defmodule Solution do
  @spec are_occurrences_equal(s :: String.t) :: boolean
  def are_occurrences_equal(s) do
    counts =
      s
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.values()

    counts |> Enum.uniq() |> length() == 1
  end
end
