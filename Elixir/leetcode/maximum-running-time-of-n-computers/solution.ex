defmodule Solution do
  @spec max_run_time(n :: integer, batteries :: [integer]) :: integer
  def max_run_time(n, batteries) do
    total = Enum.sum(batteries)
    search(n, batteries, 0, div(total, n))
  end

  defp search(n, batteries, lo, hi) when lo < hi do
    mid = div(lo + hi + 1, 2)
    avail = Enum.reduce(batteries, 0, fn b, acc -> acc + min(b, mid) end)

    if avail >= n * mid do
      search(n, batteries, mid, hi)
    else
      search(n, batteries, lo, mid - 1)
    end
  end
  defp search(_n, _batteries, lo, _hi), do: lo
end
