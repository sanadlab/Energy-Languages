public class Solution {
    public int[] SortByBits(int[] arr) {
        return arr.OrderBy(x => CountBits(x)).ThenBy(x => x).ToArray();
    }
    private int CountBits(int x) {
        int c = 0;
        while (x > 0) { c += x & 1; x >>= 1; }
        return c;
    }
}
