defmodule Solution do
  @spec reformat_date(date :: String.t) :: String.t
  def reformat_date(date) do
    months = %{
      "Jan" => "01", "Feb" => "02", "Mar" => "03", "Apr" => "04",
      "May" => "05", "Jun" => "06", "Jul" => "07", "Aug" => "08",
      "Sep" => "09", "Oct" => "10", "Nov" => "11", "Dec" => "12"
    }

    parts = String.split(date)

    if length(parts) < 3 do
      ""
    else
      [p0, p1, p2 | _] = parts

      day =
        if String.length(p0) >= 2 do
          String.slice(p0, 0, String.length(p0) - 2)
        else
          p0
        end

      day = if String.length(day) == 1, do: "0" <> day, else: day
      month = Map.get(months, p1, "01")
      p2 <> "-" <> month <> "-" <> day
    end
  end
end
