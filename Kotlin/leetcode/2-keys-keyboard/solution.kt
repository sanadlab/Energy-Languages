class Solution {
    fun minSteps(n: Int): Int {
        var res = 0
        var m = n
        var d = 2
        while (d <= m) {
            while (m % d == 0) { res += d; m /= d }
            d++
        }
        return res
    }
}
