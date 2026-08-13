# @param {String} date1
# @param {String} date2
# @return {Integer}
def days_between_dates(date1, date2)
    a = days_from_civil(parse_date(date1))
    b = days_from_civil(parse_date(date2))
    (a - b).abs
end

def parse_date(s)
    parts = s.to_s.split("-")
    vals = [0, 0, 0]
    3.times do |i|
        vals[i] = parts[i].to_i if i < parts.length
    end
    vals
end

def days_from_civil(v)
    y, m, d = v[0], v[1], v[2]
    y -= 1 if m <= 2
    era = y / 400
    yoe = y - era * 400
    mm = m > 2 ? m - 3 : m + 9
    doy = (153 * mm + 2) / 5 + d - 1
    doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
    era * 146097 + doe - 719468
end
