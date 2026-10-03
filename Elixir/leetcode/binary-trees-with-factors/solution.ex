defmodule Solution do
  @spec num_factored_binary_trees(arr :: [integer]) :: integer
  def num_factored_binary_trees(arr) do
    mod = 1_000_000_007
    sorted = Enum.sort(arr)

    {dp, _processed} =
      Enum.reduce(sorted, {%{}, []}, fn v, {dp, processed} ->
        cnt =
          Enum.reduce(processed, 1, fn a, acc ->
            if rem(v, a) == 0 do
              b = div(v, a)

              case Map.get(dp, b) do
                nil -> acc
                dpb -> acc + Map.get(dp, a) * dpb
              end
            else
              acc
            end
          end)

        {Map.put(dp, v, rem(cnt, mod)), [v | processed]}
      end)

    dp |> Map.values() |> Enum.sum() |> rem(mod)
  end
end
