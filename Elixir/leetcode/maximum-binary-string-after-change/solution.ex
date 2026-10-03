defmodule Solution do
  @spec maximum_binary_string(binary :: String.t) :: String.t
  def maximum_binary_string(binary) do
    case :binary.match(binary, "0") do
      :nomatch ->
        binary

      {first, _} ->
        n = byte_size(binary)
        zeros = Enum.count(:binary.bin_to_list(binary), &(&1 == ?0))
        pos = first + zeros - 1
        String.duplicate("1", pos) <> "0" <> String.duplicate("1", n - pos - 1)
    end
  end
end
