class Solution {
    public double average(int[] salary) {
        int mn = salary[0], mx = salary[0], sum = 0;
        for (int s : salary) { sum += s; mn = Math.min(mn, s); mx = Math.max(mx, s); }
        return (double)(sum - mn - mx) / (salary.length - 2);
    }
}
