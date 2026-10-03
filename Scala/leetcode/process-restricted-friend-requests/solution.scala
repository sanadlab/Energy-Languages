object Solution {
    def friendRequests(n: Int, restrictions: Array[Array[Int]], requests: Array[Array[Int]]): Array[Boolean] = {
        val parent = Array.range(0, n)
        def find(x0: Int): Int = {
            var x = x0
            while (parent(x) != x) {
                parent(x) = parent(parent(x))
                x = parent(x)
            }
            x
        }
        val res = scala.collection.mutable.ArrayBuffer[Boolean]()
        for (req <- requests) {
            val u = req(0)
            val v = req(1)
            val pu = find(u)
            val pv = find(v)
            if (pu == pv) {
                res += true
            } else {
                var ok = true
                var k = 0
                while (k < restrictions.length && ok) {
                    val x = restrictions(k)(0)
                    val y = restrictions(k)(1)
                    val px = find(x)
                    val py = find(y)
                    if ((px == pu && py == pv) || (px == pv && py == pu)) {
                        ok = false
                    }
                    k += 1
                }
                if (ok) {
                    parent(pu) = pv
                    res += true
                } else {
                    res += false
                }
            }
        }
        res.toArray
    }
}
