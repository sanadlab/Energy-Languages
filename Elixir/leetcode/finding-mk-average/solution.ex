defmodule MKAverage do
  @spec init_(m :: integer, k :: integer) :: any
  def init_(m, k) do
    # stream kept REVERSED for O(1) append (mirrors Python's O(1) list.append);
    # the last m elements are the first m of the reversed list.
    Process.put(:mk, {m, k, 0, []})
    nil
  end

  @spec add_element(num :: integer) :: any
  def add_element(num) do
    {m, k, n, rev} = Process.get(:mk)
    Process.put(:mk, {m, k, n + 1, [num | rev]})
    nil
  end

  @spec calculate_mk_average() :: integer
  def calculate_mk_average() do
    {m, k, n, rev} = Process.get(:mk)
    if n < m do
      -1
    else
      last = rev |> Enum.take(m) |> Enum.sort()
      trimmed = Enum.slice(last, k, m - 2 * k)
      if trimmed == [], do: 0, else: div(Enum.sum(trimmed), length(trimmed))
    end
  end
end
