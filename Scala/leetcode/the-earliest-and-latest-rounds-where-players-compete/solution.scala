object Solution {
    def earliestAndLatest(n: Int, firstPlayer: Int, secondPlayer: Int): Array[Int] = {
        val memo = scala.collection.mutable.HashMap[(Int, Int, Int), (Int, Int)]()
        def dp(m: Int, f0: Int, s0: Int): (Int, Int) = {
            var f = f0; var s = s0
            if (f > s) { val t = f; f = s; s = t }
            val key = (m, f, s)
            memo.get(key) match {
                case Some(v) => v
                case None =>
                    val result: (Int, Int) =
                        if (f + s == m + 1) (1, 1)
                        else {
                            val newM = (m + 1) / 2
                            val groups = scala.collection.mutable.ArrayBuffer[Array[Int]]()
                            for (p <- 1 to m / 2) {
                                val q = m + 1 - p
                                if (f == p || f == q) groups += Array(f)
                                else if (s == p || s == q) groups += Array(s)
                                else groups += Array(p, q)
                            }
                            if (m % 2 == 1) groups += Array((m + 1) / 2)
                            val outcomes = scala.collection.mutable.HashSet[(Int, Int)]()
                            val combo = new Array[Int](groups.length)
                            def rec(idx: Int): Unit = {
                                if (idx == groups.length) {
                                    var belowF = 0; var belowS = 0
                                    var k = 0
                                    while (k < combo.length) {
                                        if (combo(k) < f) belowF += 1
                                        if (combo(k) < s) belowS += 1
                                        k += 1
                                    }
                                    outcomes += ((belowF + 1, belowS + 1))
                                } else {
                                    for (choice <- groups(idx)) {
                                        combo(idx) = choice
                                        rec(idx + 1)
                                    }
                                }
                            }
                            rec(0)
                            var earliest = Int.MaxValue
                            var latest = Int.MinValue
                            for ((nf, ns) <- outcomes) {
                                val (e, l) = dp(newM, nf, ns)
                                earliest = math.min(earliest, e + 1)
                                latest = math.max(latest, l + 1)
                            }
                            (earliest, latest)
                        }
                    memo(key) = result
                    result
            }
        }
        val (e, l) = dp(n, firstPlayer, secondPlayer)
        Array(e, l)
    }
}
