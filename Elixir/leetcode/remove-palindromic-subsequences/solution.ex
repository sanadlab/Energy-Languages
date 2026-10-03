defmodule Solution do
  @spec remove_palindrome_sub(s :: String.t) :: integer
  def remove_palindrome_sub(s) do
    cond do
      s == "" -> 0
      s == String.reverse(s) -> 1
      true -> 2
    end
  end
end
