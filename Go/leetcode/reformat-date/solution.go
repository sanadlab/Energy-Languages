import "strings"

func reformatDate(date string) string {
    months := map[string]string{
        "Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04",
        "May": "05", "Jun": "06", "Jul": "07", "Aug": "08",
        "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"}
    parts := strings.Fields(date)
    if len(parts) < 3 {
        return ""
    }
    day := parts[0]
    if len(day) >= 2 {
        day = day[:len(day)-2]
    }
    if len(day) == 1 {
        day = "0" + day
    }
    month, ok := months[parts[1]]
    if !ok {
        month = "01"
    }
    return parts[2] + "-" + month + "-" + day
}
