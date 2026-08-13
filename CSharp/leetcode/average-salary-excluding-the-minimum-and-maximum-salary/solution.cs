public class Solution {
    public double Average(int[] salary) {
        int mn = salary[0], mx = salary[0], sum = 0;
        foreach (int s in salary) { sum += s; if (s < mn) mn = s; if (s > mx) mx = s; }
        return (double)(sum - mn - mx) / (salary.Length - 2);
    }
}
