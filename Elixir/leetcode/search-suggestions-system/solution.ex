defmodule Solution do
  @spec suggested_products(products :: [String.t], search_word :: String.t) :: [[String.t]]
  def suggested_products(products, search_word) do
    sorted = Enum.sort(products)

    {suggestions_rev, _prefix} =
      search_word
      |> String.graphemes()
      |> Enum.reduce({[], ""}, fn ch, {acc, prefix} ->
        new_prefix = prefix <> ch
        # Scan ALL products every query (no early break), matching the reference.
        matching =
          sorted
          |> Enum.filter(&String.starts_with?(&1, new_prefix))
          |> Enum.take(3)

        {[matching | acc], new_prefix}
      end)

    Enum.reverse(suggestions_rev)
  end
end
