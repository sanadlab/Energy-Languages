class Solution {
  double average(List<int> salary) {
    int mn = salary[0];
    int mx = salary[0];
    int total = 0;
    for (int s in salary) {
      total += s;
      if (s < mn) mn = s;
      if (s > mx) mx = s;
    }
    return (total - mn - mx) / (salary.length - 2);
  }
}
