defmodule Solution do
  @spec longest_str_chain(words :: [String.t]) :: integer
  def longest_str_chain(words) do
    sorted = Enum.sort_by(words, &String.length/1)

    {_dp, best} =
      Enum.reduce(sorted, {%{}, 1}, fn w, {dp, best} ->
        chars = String.graphemes(w)
        len = length(chars)

        cur =
          Enum.reduce(0..(len - 1), 1, fn i, acc ->
            pred = chars |> List.delete_at(i) |> Enum.join()

            case Map.get(dp, pred) do
              nil -> acc
              v -> max(acc, v + 1)
            end
          end)

        {Map.put(dp, w, cur), max(best, cur)}
      end)

    best
  end
end
