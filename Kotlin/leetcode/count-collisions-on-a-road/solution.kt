class Solution {
    fun countCollisions(directions: String): Int {
        val n = directions.length
        var i = 0
        while (i < n && directions[i] == 'L') i++
        var j = n - 1
        while (j >= 0 && directions[j] == 'R') j--
        var collisions = 0
        for (k in i..j) {
            if (directions[k] != 'S') collisions++
        }
        return collisions
    }
}
