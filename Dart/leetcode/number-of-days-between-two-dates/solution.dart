class Solution {
  int daysBetweenDates(String date1, String date2) {
    int a = _days(date1);
    int b = _days(date2);
    return (a - b).abs();
  }

  int _days(String s) {
    List<String> parts = s.split("-");
    List<int> vals = [0, 0, 0];
    int lim = parts.length < 3 ? parts.length : 3;
    for (int i = 0; i < lim; i++) {
      vals[i] = int.tryParse(parts[i]) ?? 0;
    }
    return _daysFromCivil(vals[0], vals[1], vals[2]);
  }

  int _daysFromCivil(int y, int m, int d) {
    y -= m <= 2 ? 1 : 0;
    int era = y ~/ 400;
    int yoe = y - era * 400;
    int doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) ~/ 5 + d - 1;
    int doe = yoe * 365 + yoe ~/ 4 - yoe ~/ 100 + doy;
    return era * 146097 + doe - 719468;
  }
}
