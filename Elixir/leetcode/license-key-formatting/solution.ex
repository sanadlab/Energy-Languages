defmodule Solution do
  @spec license_key_formatting(s :: String.t, k :: integer) :: String.t
  def license_key_formatting(s, k) do
    cleaned = s |> String.replace("-", "") |> String.upcase()
    chars = String.graphemes(cleaned)
    first_group_len = rem(length(chars), k)

    {head, rest} = Enum.split(chars, first_group_len)

    head_groups = if first_group_len > 0, do: [Enum.join(head)], else: []
    rest_groups = rest |> Enum.chunk_every(k) |> Enum.map(&Enum.join/1)

    Enum.join(head_groups ++ rest_groups, "-")
  end
end
