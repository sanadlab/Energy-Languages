public class Solution {
    public int MinNumberOperations(int[] target) {
        if (target.Length == 0) return 0;
        long ans = target[0];
        for (int i = 1; i < target.Length; i++) {
            if (target[i] > target[i-1]) ans += target[i] - target[i-1];
        }
        return (int)ans;
    }
}
