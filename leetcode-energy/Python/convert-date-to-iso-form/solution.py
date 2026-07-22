class Solution:
    def reformatDate(self, date: str) -> str:
        day_str, month_str, year_str = date.split()
        
        # Remove the suffix from the day (e.g., "20th" -> "20")
        day = ''.join(filter(str.isdigit, day_str))
        
        # Map month abbreviation to month number
        months = {
            "Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04",
            "May": "05", "Jun": "06", "Jul": "07", "Aug": "08",
            "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"
        }
        
        month = months[month_str]
        
        # Format day with leading zero if needed
        day = day.zfill(2)
        
        return f"{year_str}-{month}-{day}"
