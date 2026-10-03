defmodule Solution do
  @spec xor_operation(n :: integer, start :: integer) :: integer
  def xor_operation(n, start) do
    Enum.reduce(0..(n - 1)//1, 0, fn i, acc -> Bitwise.bxor(acc, start + 2 * i) end)
  end
end
