import (
    "strconv"
    "strings"
)

func daysBetweenDates(date1 string, date2 string) int {
    y1, m1, d1 := parseDate(date1)
    y2, m2, d2 := parseDate(date2)
    a := daysFromCivil(y1, m1, d1)
    b := daysFromCivil(y2, m2, d2)
    diff := a - b
    if diff < 0 {
        diff = -diff
    }
    return diff
}

func parseDate(s string) (int, int, int) {
    parts := strings.Split(s, "-")
    vals := [3]int{0, 0, 0}
    for i := 0; i < 3 && i < len(parts); i++ {
        v, _ := strconv.Atoi(parts[i])
        vals[i] = v
    }
    return vals[0], vals[1], vals[2]
}

func daysFromCivil(y, m, d int) int {
    if m <= 2 {
        y--
    }
    var era int
    if y >= 0 {
        era = y / 400
    } else {
        era = (y - 399) / 400
    }
    yoe := y - era*400
    mm := m + 9
    if m > 2 {
        mm = m - 3
    }
    doy := (153*mm+2)/5 + d - 1
    doe := yoe*365 + yoe/4 - yoe/100 + doy
    return era*146097 + doe - 719468
}
