defmodule Solution do
  @spec is_solvable(words :: [String.t], result :: String.t) :: boolean
  def is_solvable(words, result) do
    max_len = String.length(result)

    if Enum.any?(words, fn w -> String.length(w) > max_len end) do
      false
    else
      words_t =
        words
        |> Enum.map(fn w -> w |> String.graphemes() |> Enum.reverse() |> List.to_tuple() end)
        |> List.to_tuple()

      rrev = result |> String.graphemes() |> Enum.reverse() |> List.to_tuple()

      ctx = %{
        words_t: words_t,
        rrev: rrev,
        nwords: length(words),
        max_len: max_len,
        leading: build_leading(words, result)
      }

      solve(0, 0, 0, %{}, %{}, ctx)
    end
  end

  defp build_leading(words, result) do
    s =
      Enum.reduce(words, MapSet.new(), fn w, acc ->
        if String.length(w) > 1, do: MapSet.put(acc, String.first(w)), else: acc
      end)

    if String.length(result) > 1, do: MapSet.put(s, String.first(result)), else: s
  end

  defp solve(col, row, carry, assigned, used, ctx) do
    cond do
      col == ctx.max_len ->
        carry == 0

      row < ctx.nwords ->
        solve_word(col, row, carry, assigned, used, ctx)

      true ->
        solve_result(col, carry, assigned, used, ctx)
    end
  end

  defp solve_word(col, row, carry, assigned, used, ctx) do
    wrev = elem(ctx.words_t, row)

    cond do
      col >= tuple_size(wrev) ->
        solve(col, row + 1, carry, assigned, used, ctx)

      true ->
        ch = elem(wrev, col)

        if Map.has_key?(assigned, ch) do
          solve(col, row + 1, carry, assigned, used, ctx)
        else
          try_word_digits(0, col, row, carry, ch, assigned, used, ctx)
        end
    end
  end

  defp solve_result(col, carry, assigned, used, ctx) do
    s =
      Enum.reduce(0..(ctx.nwords - 1)//1, carry, fn r, acc ->
        wrev = elem(ctx.words_t, r)
        if col < tuple_size(wrev), do: acc + Map.fetch!(assigned, elem(wrev, col)), else: acc
      end)

    digit = rem(s, 10)
    new_carry = div(s, 10)
    rch = elem(ctx.rrev, col)

    cond do
      Map.has_key?(assigned, rch) ->
        if Map.fetch!(assigned, rch) == digit,
          do: solve(col + 1, 0, new_carry, assigned, used, ctx),
          else: false

      Map.get(used, digit, false) ->
        false

      digit == 0 and MapSet.member?(ctx.leading, rch) ->
        false

      true ->
        solve(
          col + 1,
          0,
          new_carry,
          Map.put(assigned, rch, digit),
          Map.put(used, digit, true),
          ctx
        )
    end
  end

  defp try_word_digits(10, _col, _row, _carry, _ch, _assigned, _used, _ctx), do: false

  defp try_word_digits(d, col, row, carry, ch, assigned, used, ctx) do
    if not Map.get(used, d, false) and not (d == 0 and MapSet.member?(ctx.leading, ch)) and
         solve(col, row + 1, carry, Map.put(assigned, ch, d), Map.put(used, d, true), ctx) do
      true
    else
      try_word_digits(d + 1, col, row, carry, ch, assigned, used, ctx)
    end
  end
end
