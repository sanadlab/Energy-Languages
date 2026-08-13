public class Solution {
    public int[] KWeakestRows(int[][] mat, int k) {
        int lim = Math.Min(k, mat.Length);
        return mat.Select((row, i) => (count: row.Count(v => v == 1), idx: i))
                  .OrderBy(t => t.count).ThenBy(t => t.idx)
                  .Take(lim).Select(t => t.idx).ToArray();
    }
}
