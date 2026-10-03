defmodule Solution do
  @spec days_between_dates(date1 :: String.t, date2 :: String.t) :: integer
  def days_between_dates(date1, date2) do
    abs(days(date1) - days(date2))
  end

  defp days(s) do
    parts = String.split(s, "-")

    [y, m, d] =
      Enum.map(0..2, fn i ->
        case Enum.at(parts, i) do
          nil -> 0
          p ->
            case Integer.parse(p) do
              {v, _} -> v
              :error -> 0
            end
        end
      end)

    days_from_civil(y, m, d)
  end

  defp days_from_civil(y, m, d) do
    y = if m <= 2, do: y - 1, else: y
    era = div(y, 400)
    yoe = y - era * 400
    doy = div(153 * (m + if(m > 2, do: -3, else: 9)) + 2, 5) + d - 1
    doe = yoe * 365 + div(yoe, 4) - div(yoe, 100) + doy
    era * 146097 + doe - 719468
  end
end
