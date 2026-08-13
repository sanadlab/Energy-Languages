public class Solution {
    public IList<bool> KidsWithCandies(int[] candies, int extraCandies) {
        int mx = candies.Max();
        var res = new List<bool>();
        foreach (int c in candies) res.Add(c + extraCandies >= mx);
        return res;
    }
}
