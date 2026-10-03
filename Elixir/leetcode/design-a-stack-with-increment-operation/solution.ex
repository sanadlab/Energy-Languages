defmodule CustomStack do
  @spec init_(max_size :: integer) :: any
  def init_(max_size) do
    # State: {max_size, size, vals_map, inc_map}. vals/inc keyed by 0-based
    # index from the bottom, mirroring the reference's parallel arrays. Maps
    # give O(1) random access so increment/pop stay O(1) like the reference.
    Process.put(:cs, {max_size, 0, %{}, %{}})
    nil
  end

  @spec push(x :: integer) :: any
  def push(x) do
    {max, size, vals, inc} = Process.get(:cs)

    if size < max do
      Process.put(:cs, {max, size + 1, Map.put(vals, size, x), Map.put(inc, size, 0)})
    end

    nil
  end

  @spec pop() :: integer
  def pop() do
    {max, size, vals, inc} = Process.get(:cs)

    if size == 0 do
      -1
    else
      i = size - 1
      v = Map.get(vals, i) + Map.get(inc, i)

      inc1 =
        if i > 0 do
          Map.update!(inc, i - 1, &(&1 + Map.get(inc, i)))
        else
          inc
        end

      Process.put(:cs, {max, i, Map.delete(vals, i), Map.delete(inc1, i)})
      v
    end
  end

  @spec increment(k :: integer, val :: integer) :: any
  def increment(k, val) do
    {max, size, vals, inc} = Process.get(:cs)
    i = min(k, size) - 1

    if i >= 0 do
      Process.put(:cs, {max, size, vals, Map.update!(inc, i, &(&1 + val))})
    end

    nil
  end
end
