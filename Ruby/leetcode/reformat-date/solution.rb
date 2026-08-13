# @param {String} date
# @return {String}
def reformat_date(date)
    months = {"Jan"=>"01","Feb"=>"02","Mar"=>"03","Apr"=>"04",
              "May"=>"05","Jun"=>"06","Jul"=>"07","Aug"=>"08",
              "Sep"=>"09","Oct"=>"10","Nov"=>"11","Dec"=>"12"}
    parts = date.split
    return "" if parts.length < 3
    day = parts[0].length >= 2 ? parts[0][0...-2] : parts[0]
    day = "0" + day if day.length == 1
    month = months[parts[1]] || "01"
    "#{parts[2]}-#{month}-#{day}"
end
