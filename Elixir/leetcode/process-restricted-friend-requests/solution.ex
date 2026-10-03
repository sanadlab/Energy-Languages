defmodule Solution do
  @spec friend_requests(n :: integer, restrictions :: [[integer]], requests :: [[integer]]) :: [boolean]
  def friend_requests(n, restrictions, requests) do
    parent = Map.new(0..(n - 1), fn i -> {i, i} end)

    {_parent, res} =
      Enum.reduce(requests, {parent, []}, fn [u, v], {parent, acc} ->
        {pu, parent} = find(parent, u)
        {pv, parent} = find(parent, v)

        if pu == pv do
          {parent, [true | acc]}
        else
          {ok, parent} = check_restrictions(restrictions, parent, pu, pv)

          if ok do
            {Map.put(parent, pu, pv), [true | acc]}
          else
            {parent, [false | acc]}
          end
        end
      end)

    Enum.reverse(res)
  end

  defp find(parent, x) do
    p = Map.get(parent, x)

    if p == x do
      {x, parent}
    else
      gp = Map.get(parent, p)
      find(Map.put(parent, x, gp), gp)
    end
  end

  defp check_restrictions([], parent, _pu, _pv), do: {true, parent}
  defp check_restrictions([[x, y] | rest], parent, pu, pv) do
    {px, parent} = find(parent, x)
    {py, parent} = find(parent, y)

    if (px == pu and py == pv) or (px == pv and py == pu) do
      {false, parent}
    else
      check_restrictions(rest, parent, pu, pv)
    end
  end
end
