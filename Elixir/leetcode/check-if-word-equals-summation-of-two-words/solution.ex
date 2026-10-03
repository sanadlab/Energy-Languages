defmodule Solution do
  @spec is_sum_equal(first_word :: String.t, second_word :: String.t, target_word :: String.t) :: boolean
  def is_sum_equal(first_word, second_word, target_word) do
    word_to_num(first_word) + word_to_num(second_word) == word_to_num(target_word)
  end

  defp word_to_num(word) do
    word
    |> :binary.bin_to_list()
    |> Enum.reduce(0, fn c, num -> num * 10 + (c - ?a) end)
  end
end
