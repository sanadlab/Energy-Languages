defmodule Solution do
  @spec evaluate(s :: String.t, knowledge :: [[String.t]]) :: String.t
  def evaluate(s, knowledge) do
    dict = Map.new(knowledge, fn [k, v] -> {k, v} end)

    {_stack, word} =
      s
      |> String.to_charlist()
      |> Enum.reduce({[], []}, fn ch, {stack, word} ->
        cond do
          ch == ?( ->
            {[word | stack], []}

          ch == ?) ->
            [prev | rest] = stack
            key = IO.iodata_to_binary(word)
            val = Map.get(dict, key, "?")
            {rest, [prev, val]}

          true ->
            {stack, [word, ch]}
        end
      end)

    IO.iodata_to_binary(word)
  end
end
