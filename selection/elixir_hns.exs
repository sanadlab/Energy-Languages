# Shared helpers for the Elixir loop-harness (harness.exs) and the full-suite
# validator (validate_suite.exs). Mirrors selection/harness.rb semantics so
# Elixir cells are measured + judged on the SAME shared JSON inputs as every
# other language. The canon/fold form only needs to be INTERNALLY consistent
# (both sides of a comparison go through the same canon here), not byte-match
# any other language's serialization.
#
# LeetCode Elixir uses %TreeNode{}/%ListNode{} structs (nil = empty) and
# snake_case function names; the shared entry_point / design ops are camelCase,
# so names are converted with underscore/1.

defmodule TreeNode do
  defstruct val: 0, left: nil, right: nil
end

defmodule ListNode do
  defstruct val: 0, next: nil
end

defmodule HNS do
  import Bitwise

  @mask64 (1 <<< 64) - 1

  # ---- ordered JSON decode (hand-rolled; no OTP :json dependency) -------------
  # Objects are tagged {:object, [{key, value}, ...]} in SOURCE order so the
  # generic single-method path can recover parameter order (Elixir maps do not
  # preserve key order). Arrays stay plain lists; null -> nil. Works on any OTP.
  def parse_ordered(bin) do
    {v, _rest} = pval(skip_ws(bin))
    v
  end

  defp skip_ws(<<c, r::binary>>) when c in [32, 9, 10, 13], do: skip_ws(r)
  defp skip_ws(b), do: b

  defp pval(<<?{, r::binary>>), do: pobj(skip_ws(r), [])
  defp pval(<<?[, r::binary>>), do: parr(skip_ws(r), [])
  defp pval(<<?", r::binary>>), do: pstr(r, [])
  defp pval(<<"true", r::binary>>), do: {true, r}
  defp pval(<<"false", r::binary>>), do: {false, r}
  defp pval(<<"null", r::binary>>), do: {nil, r}
  defp pval(b), do: pnum(b)

  defp pobj(<<?}, r::binary>>, acc), do: {{:object, Enum.reverse(acc)}, r}
  defp pobj(<<?", r::binary>>, acc) do
    {k, r1} = pstr(r, [])
    <<?:, r2::binary>> = skip_ws(r1)
    {v, r3} = pval(skip_ws(r2))
    case skip_ws(r3) do
      <<?,, r4::binary>> -> pobj(skip_ws(r4), [{k, v} | acc])
      <<?}, r4::binary>> -> {{:object, Enum.reverse([{k, v} | acc])}, r4}
    end
  end

  defp parr(<<?], r::binary>>, acc), do: {Enum.reverse(acc), r}
  defp parr(b, acc) do
    {v, r1} = pval(b)
    case skip_ws(r1) do
      <<?,, r2::binary>> -> parr(skip_ws(r2), [v | acc])
      <<?], r2::binary>> -> {Enum.reverse([v | acc]), r2}
    end
  end

  defp pstr(<<?", r::binary>>, acc), do: {IO.iodata_to_binary(Enum.reverse(acc)), r}
  defp pstr(<<?\\, ?u, h::binary-size(4), r::binary>>, acc), do: pstr(r, [<<String.to_integer(h, 16)::utf8>> | acc])
  defp pstr(<<?\\, c, r::binary>>, acc), do: pstr(r, [unesc(c) | acc])
  defp pstr(<<c, r::binary>>, acc), do: pstr(r, [c | acc])

  defp unesc(?n), do: ?\n
  defp unesc(?t), do: ?\t
  defp unesc(?r), do: ?\r
  defp unesc(?b), do: ?\b
  defp unesc(?f), do: ?\f
  defp unesc(c), do: c

  defp pnum(b) do
    {tok, r} = take_num(b, [])
    s = IO.iodata_to_binary(Enum.reverse(tok))
    v =
      case Integer.parse(s) do
        {i, ""} -> i
        _ -> {f, _} = Float.parse(s); f
      end
    {v, r}
  end

  defp take_num(<<c, r::binary>>, acc) when c in [?-, ?+, ?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?., ?e, ?E],
    do: take_num(r, [c | acc])
  defp take_num(b, acc), do: {acc, b}

  def obj_get({:object, pairs}, key, default \\ nil) do
    case List.keyfind(pairs, key, 0) do
      {_, v} -> v
      nil -> default
    end
  end

  def obj_pairs({:object, pairs}), do: pairs

  # ---- camelCase -> snake_case (Rails "underscore") ---------------------------
  def underscore(s) do
    s
    |> to_string()
    |> String.replace(~r/([A-Z]+)([A-Z][a-z])/, "\\1_\\2")
    |> String.replace(~r/([a-z\d])([A-Z])/, "\\1_\\2")
    |> String.downcase()
  end

  def snake_atom(s), do: String.to_atom(underscore(s))

  # ---- node construction (compact LeetCode level-order) -----------------------
  # Two passes: assign ids by BFS honoring the compact layout (nil children take
  # a slot but do NOT enqueue), then assemble the immutable structs top-down.
  def build_tree(nil), do: nil
  def build_tree([]), do: nil
  def build_tree([nil | _]), do: nil
  def build_tree([rv | rest]) when is_list([rv | rest]) do
    {valmap, childmap} = bfs_assign([0], rest, %{0 => rv}, %{}, 1)
    assemble(0, valmap, childmap)
  end

  defp bfs_assign(_q, [], valmap, childmap, _next), do: {valmap, childmap}
  defp bfs_assign([], _rest, valmap, childmap, _next), do: {valmap, childmap}
  defp bfs_assign([pid | q], rest, valmap, childmap, next) do
    {lv, rest1} = take(rest)
    {rv, rest2} = take(rest1)
    {valmap1, childmap1, q1, next1} = put_child(valmap, childmap, q, next, pid, :left, lv)
    {valmap2, childmap2, q2, next2} = put_child(valmap1, childmap1, q1, next1, pid, :right, rv)
    bfs_assign(q2, rest2, valmap2, childmap2, next2)
  end

  defp take([]), do: {:none, []}
  defp take([h | t]), do: {{:val, h}, t}

  defp put_child(valmap, childmap, q, next, _pid, _side, :none), do: {valmap, childmap, q, next}
  defp put_child(valmap, childmap, q, next, _pid, _side, {:val, nil}), do: {valmap, childmap, q, next}
  defp put_child(valmap, childmap, q, next, pid, side, {:val, v}) do
    id = next
    valmap1 = Map.put(valmap, id, v)
    childmap1 = Map.update(childmap, pid, %{side => id}, &Map.put(&1, side, id))
    {valmap1, childmap1, q ++ [id], id + 1}
  end

  defp assemble(id, valmap, childmap) do
    kids = Map.get(childmap, id, %{})
    %TreeNode{
      val: Map.get(valmap, id),
      left: child_or_nil(Map.get(kids, :left), valmap, childmap),
      right: child_or_nil(Map.get(kids, :right), valmap, childmap)
    }
  end

  defp child_or_nil(nil, _vm, _cm), do: nil
  defp child_or_nil(id, vm, cm), do: assemble(id, vm, cm)

  def build_list(nil), do: nil
  def build_list([]), do: nil
  def build_list(a) when is_list(a) do
    a |> Enum.reverse() |> Enum.reduce(nil, fn v, acc -> %ListNode{val: v, next: acc} end)
  end

  def tree_to_list(nil), do: []
  def tree_to_list(root), do: trim_trailing_nil(bfs([root], []))

  defp bfs([], acc), do: Enum.reverse(acc)
  defp bfs([nil | q], acc), do: bfs(q, [nil | acc])
  defp bfs([%TreeNode{val: v, left: l, right: r} | q], acc), do: bfs(q ++ [l, r], [v | acc])

  defp trim_trailing_nil(list) do
    list |> Enum.reverse() |> Enum.drop_while(&is_nil/1) |> Enum.reverse()
  end

  def list_to_list(nil), do: []
  def list_to_list(%ListNode{val: v, next: n}), do: [v | list_to_list(n)]

  # ---- canonical form (internally consistent) ---------------------------------
  def canon(nil), do: "null"
  def canon(true), do: "true"
  def canon(false), do: "false"
  def canon(v) when is_integer(v), do: Integer.to_string(v)
  def canon(v) when is_float(v) do
    t = trunc(v)
    if v == t, do: Integer.to_string(t), else: Float.to_string(v)
  end
  def canon(v) when is_binary(v), do: json_string(v)
  def canon(%TreeNode{} = t), do: canon(tree_to_list(t))
  def canon(%ListNode{} = l), do: canon(list_to_list(l))
  def canon({:object, pairs}), do: canon_obj(pairs)
  def canon(v) when is_list(v), do: "[" <> Enum.map_join(v, ",", &canon/1) <> "]"
  def canon(v) when is_map(v), do: canon_obj(Map.to_list(v))
  def canon(v) when is_atom(v), do: json_string(Atom.to_string(v))
  def canon(v), do: json_string(to_string(v))

  defp canon_obj(pairs) do
    body =
      pairs
      |> Enum.map(fn {k, v} -> {to_string(k), v} end)
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map_join(",", fn {k, v} -> json_string(k) <> ":" <> canon(v) end)
    "{" <> body <> "}"
  end

  defp json_string(s) do
    esc =
      s
      |> String.replace("\\", "\\\\")
      |> String.replace("\"", "\\\"")
      |> String.replace("\n", "\\n")
      |> String.replace("\t", "\\t")
    "\"" <> esc <> "\""
  end

  # ---- checksum fold ----------------------------------------------------------
  def strhash(s) do
    s |> :binary.bin_to_list() |> Enum.reduce(0, fn b, h -> band(h * 31 + b, 0xFFFFFFFF) end)
  end

  def fold(acc, r), do: band(acc * 1_000_003 + strhash(canon(r)), @mask64)

  # ---- build positional args from an ordered input object ---------------------
  # root -> tree, head -> list, everything else passes through unchanged.
  def build_args({:object, pairs}) do
    Enum.map(pairs, fn {k, v} ->
      cond do
        k == "root" -> build_tree(v)
        k == "head" -> build_list(v)
        true -> v
      end
    end)
  end

  def design?({:object, pairs}), do: List.keymember?(pairs, "ops", 0) and List.keymember?(pairs, "args", 0)
  def design?(_), do: false

  # Resolve the actual function name: snake_case first, camel fallback (both as
  # atoms), defaulting to snake. `mod` must already be loaded.
  def resolve(mod, camel, arity) do
    snake = snake_atom(camel)
    camel_atom = String.to_atom(to_string(camel))
    cond do
      function_exported?(mod, snake, arity) -> snake
      function_exported?(mod, camel_atom, arity) -> camel_atom
      true -> snake
    end
  end
end
