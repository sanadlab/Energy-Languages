object Solution {
    def countCollisions(directions: String): Int = {
        val n = directions.length
        var i = 0
        while (i < n && directions(i) == 'L') i += 1
        var j = n - 1
        while (j >= 0 && directions(j) == 'R') j -= 1
        var collisions = 0
        var k = i
        while (k <= j) {
            if (directions(k) != 'S') collisions += 1
            k += 1
        }
        collisions
    }
}
