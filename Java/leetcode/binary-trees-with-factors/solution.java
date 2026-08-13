import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

class Solution {
    public int numFactoredBinaryTrees(int[] arr) {
        final long MOD = 1000000007L;
        Arrays.sort(arr);
        Map<Integer, Long> dp = new HashMap<>();
        long ans = 0;
        for (int i = 0; i < arr.length; i++) {
            long cnt = 1;
            for (int j = 0; j < i; j++) {
                if (arr[i] % arr[j] == 0) {
                    int b = arr[i] / arr[j];
                    Long bv = dp.get(b);
                    if (bv != null) {
                        cnt = (cnt + dp.get(arr[j]) * bv) % MOD;
                    }
                }
            }
            dp.put(arr[i], cnt);
            ans = (ans + cnt) % MOD;
        }
        return (int) ans;
    }
}
