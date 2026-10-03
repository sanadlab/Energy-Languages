defmodule Solution do
  @spec ladder_length(begin_word :: String.t, end_word :: String.t, word_list :: [String.t]) :: integer
  def ladder_length(begin_word, end_word, word_list) do
    word_set = MapSet.new(word_list)

    if not MapSet.member?(word_set, end_word) do
      0
    else
      q = :queue.from_list([{begin_word, 1}])
      visited = MapSet.new([begin_word])
      bfs(q, visited, word_set, end_word)
    end
  end

  defp bfs(q, visited, word_set, end_word) do
    case :queue.out(q) do
      {:empty, _} ->
        0

      {{:value, {word, level}}, q2} ->
        case expand(neighbors(word), level, q2, visited, word_set, end_word) do
          {:found, result} -> result
          {q3, visited3} -> bfs(q3, visited3, word_set, end_word)
        end
    end
  end

  defp expand(candidates, level, q, visited, word_set, end_word) do
    Enum.reduce_while(candidates, {q, visited}, fn nw, {q_acc, v_acc} ->
      cond do
        nw == end_word ->
          {:halt, {:found, level + 1}}

        MapSet.member?(word_set, nw) and not MapSet.member?(v_acc, nw) ->
          {:cont, {:queue.in({nw, level + 1}, q_acc), MapSet.put(v_acc, nw)}}

        true ->
          {:cont, {q_acc, v_acc}}
      end
    end)
  end

  # all words that differ from `word` by exactly one position (26 letters each)
  defp neighbors(word) do
    chars = String.to_charlist(word)
    len = length(chars)

    Enum.flat_map(0..(len - 1), fn i ->
      {prefix, [_old | suffix]} = Enum.split(chars, i)
      Enum.map(?a..?z, fn c -> List.to_string(prefix ++ [c] ++ suffix) end)
    end)
  end
end
