defmodule Solution do
  @spec ambiguous_coordinates(s :: String.t) :: [String.t]
  def ambiguous_coordinates(s) do
    digits = String.slice(s, 1, String.length(s) - 2)
    n = String.length(digits)

    for i <- 1..(n - 1)//1,
        a <- make(String.slice(digits, 0, i)),
        b <- make(String.slice(digits, i, n - i)) do
      "(" <> a <> ", " <> b <> ")"
    end
  end

  defp make(d) do
    n = String.length(d)

    if n == 1 do
      [d]
    else
      head = if String.first(d) != "0", do: [d], else: []

      rest =
        for i <- 1..(n - 1)//1,
            l = String.slice(d, 0, i),
            r = String.slice(d, i, n - i),
            (l == "0" or String.first(l) != "0") and String.last(r) != "0" do
          l <> "." <> r
        end

      head ++ rest
    end
  end
end
