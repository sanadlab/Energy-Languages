import java.util.*;

class Solution {
    public List<Boolean> kidsWithCandies(int[] candies, int extraCandies) {
        int mx = 0;
        for (int c : candies) mx = Math.max(mx, c);
        List<Boolean> res = new ArrayList<>();
        for (int c : candies) res.add(c + extraCandies >= mx);
        return res;
    }
}
