defmodule Solution do
  import Bitwise

  @spec max_score(nums :: [integer]) :: integer
  def max_score(nums) do
    m = length(nums)
    t = List.to_tuple(nums)
    full = 1 <<< m

    {_dp, best} =
      Enum.reduce(0..(full - 1), {%{}, 0}, fn mask, {dp, best} ->
        cnt = popcount(mask)

        if band(cnt, 1) == 1 do
          {dp, best}
        else
          op = div(cnt, 2) + 1
          cur = Map.get(dp, mask, 0)

          Enum.reduce(0..(m - 1)//1, {dp, best}, fn i, {dp, best} ->
            if band(bsr(mask, i), 1) == 1 do
              {dp, best}
            else
              Enum.reduce((i + 1)..(m - 1)//1, {dp, best}, fn j, {dp, best} ->
                if band(bsr(mask, j), 1) == 1 do
                  {dp, best}
                else
                  nm = mask ||| (1 <<< i) ||| (1 <<< j)
                  val = cur + op * Integer.gcd(elem(t, i), elem(t, j))

                  if val > Map.get(dp, nm, 0) do
                    {Map.put(dp, nm, val), max(best, val)}
                  else
                    {dp, best}
                  end
                end
              end)
            end
          end)
        end
      end)

    best
  end

  defp popcount(0), do: 0
  defp popcount(x), do: band(x, 1) + popcount(bsr(x, 1))
end
