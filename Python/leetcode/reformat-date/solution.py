class Solution:
    def reformatDate(self, date: str) -> str:
        months = {"Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04",
                  "May": "05", "Jun": "06", "Jul": "07", "Aug": "08",
                  "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"}
        parts = date.split()
        if len(parts) < 3:
            return ""
        day = parts[0][:-2] if len(parts[0]) >= 2 else parts[0]
        if len(day) == 1:
            day = "0" + day
        month = months.get(parts[1], "01")
        return parts[2] + "-" + month + "-" + day
