class Solution:
    def daysBetweenDates(self, date1: str, date2: str) -> int:
        a = self._days(date1)
        b = self._days(date2)
        return abs(a - b)

    def _days(self, s: str) -> int:
        parts = str(s).split("-")
        vals = [0, 0, 0]
        for i in range(min(3, len(parts))):
            try:
                vals[i] = int(parts[i])
            except ValueError:
                vals[i] = 0
        return self._days_from_civil(vals[0], vals[1], vals[2])

    def _days_from_civil(self, y: int, m: int, d: int) -> int:
        y -= 1 if m <= 2 else 0
        era = y // 400
        yoe = y - era * 400
        doy = (153 * (m + (-3 if m > 2 else 9)) + 2) // 5 + d - 1
        doe = yoe * 365 + yoe // 4 - yoe // 100 + doy
        return era * 146097 + doe - 719468
