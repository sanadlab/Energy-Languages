defmodule Solution do
  @spec shift_grid(grid :: [[integer]], k :: integer) :: [[integer]]
  def shift_grid(grid, k) do
    m = length(grid)

    if m == 0 do
      grid
    else
      n = length(hd(grid))

      if n == 0 do
        grid
      else
        total = m * n
        k = rem(k, total)
        flat = grid |> Enum.concat() |> List.to_tuple()

        for i <- 0..(m - 1)//1 do
          for j <- 0..(n - 1)//1 do
            p = i * n + j
            src = rem(p - k + total, total)
            elem(flat, src)
          end
        end
      end
    end
  end
end
