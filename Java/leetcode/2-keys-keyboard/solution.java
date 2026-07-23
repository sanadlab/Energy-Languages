// Reference Java solution for 2-keys-keyboard.
// In production this file is overwritten by the model's submitted
// code at arena-runner dispatch time; for the demo it's a working
// implementation so the test suite has something to call.
class Solution {
    public int minSteps(int n) {
        if (n == 1) return 0;
        int ans = 0, d = 2;
        while (n > 1) {
            while (n % d == 0) {
                ans += d;
                n /= d;
            }
            d++;
        }
        return ans;
    }
}
