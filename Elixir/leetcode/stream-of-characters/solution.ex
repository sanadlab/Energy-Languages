defmodule StreamChecker do
  @spec init_(words :: [String.t]) :: any
  def init_(words) do
    {trie, max_len} =
      Enum.reduce(words, {%{}, 0}, fn w, {t, ml} ->
        {add_word(t, w), max(ml, String.length(w))}
      end)

    Process.put(:sc_trie, trie)
    Process.put(:sc_stream, [])
    Process.put(:sc_maxlen, max_len)
    nil
  end

  @spec query(letter :: char) :: boolean
  def query(letter) do
    stream = [letter | Process.get(:sc_stream)]
    Process.put(:sc_stream, stream)
    walk(Process.get(:sc_trie), stream, Process.get(:sc_maxlen))
  end

  # Insert a word into the trie in REVERSED order (suffix trie), matching the
  # reference. Terminal nodes carry a :end marker.
  defp add_word(trie, w) do
    chars = w |> String.graphemes() |> Enum.reverse()
    insert(trie, chars)
  end

  defp insert(node, []), do: Map.put(node, :end, true)

  defp insert(node, [c | rest]) do
    child = Map.get(node, c, %{})
    Map.put(node, c, insert(child, rest))
  end

  # Walk the trie against the stream (most-recent char first) for up to max_len
  # steps, the full per-query walk.
  defp walk(_node, _chars, 0), do: false
  defp walk(_node, [], _steps), do: false

  defp walk(node, [ch | rest], steps) do
    case Map.get(node, ch) do
      nil ->
        false

      child ->
        if Map.get(child, :end), do: true, else: walk(child, rest, steps - 1)
    end
  end
end

# Your functions will be called as such:
# StreamChecker.init_(words)
# param_1 = StreamChecker.query(letter)
