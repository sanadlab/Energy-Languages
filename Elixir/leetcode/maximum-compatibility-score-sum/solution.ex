defmodule Solution do
  import Bitwise

  @spec max_compatibility_sum(students :: [[integer]], mentors :: [[integer]]) :: integer
  def max_compatibility_sum(students, mentors) do
    m = length(students)

    if m == 0 do
      0
    else
      n = length(hd(students))
      stu = students |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
      men = mentors |> Enum.map(&List.to_tuple/1) |> List.to_tuple()

      score =
        for i <- 0..(m - 1)//1, into: %{} do
          row =
            for j <- 0..(m - 1)//1, into: %{} do
              s = Enum.count(0..(n - 1)//1, fn k -> elem(elem(stu, i), k) == elem(elem(men, j), k) end)
              {j, s}
            end

          {i, row}
        end

      full = (1 <<< m) - 1
      dp0 = %{}

      dp =
        Enum.reduce(0..full//1, dp0, fn mask, dp ->
          i = popcount(mask)

          if i >= m do
            dp
          else
            Enum.reduce(0..(m - 1)//1, dp, fn j, dp ->
              if ((mask >>> j) &&& 1) == 1 do
                dp
              else
                nm = mask ||| (1 <<< j)
                val = Map.get(dp, mask, 0) + score[i][j]
                if val > Map.get(dp, nm, 0), do: Map.put(dp, nm, val), else: dp
              end
            end)
          end
        end)

      Map.get(dp, full, 0)
    end
  end

  defp popcount(0), do: 0
  defp popcount(x), do: (x &&& 1) + popcount(x >>> 1)
end
