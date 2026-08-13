public class Solution {
    public int MaxTotalFruits(int[][] fruits, int startPos, int k) {
        int n = fruits.Length;
        int best = 0, sum = 0, i = 0;
        for (int j = 0; j < n; j++) {
            sum += fruits[j][1];
            while (i <= j && Cost(fruits[i][0], fruits[j][0], startPos) > k) {
                sum -= fruits[i][1];
                i++;
            }
            if (i <= j && sum > best) best = sum;
        }
        return best;
    }

    private int Cost(int posL, int posR, int startPos) {
        if (posR <= startPos) return startPos - posL;
        if (posL >= startPos) return posR - startPos;
        return (posR - posL) + Math.Min(startPos - posL, posR - startPos);
    }
}
