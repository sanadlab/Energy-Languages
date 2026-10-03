class Solution {
    fun minNumberOperations(target: IntArray): Int {
        if (target.isEmpty()) return 0
        var ans = target[0]
        for (i in 1 until target.size) {
            if (target[i] > target[i - 1]) ans += target[i] - target[i - 1]
        }
        return ans
    }
}
