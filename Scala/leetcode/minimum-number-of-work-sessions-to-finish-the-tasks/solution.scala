object Solution {
    def minSessions(tasks: Array[Int], sessionTime: Int): Int = {
        val n = tasks.length
        val full = (1 << n) - 1
        val INF = Int.MaxValue
        val sessions = Array.fill(1 << n)(INF)
        val used = Array.fill(1 << n)(0)
        sessions(0) = 1
        for (mask <- 0 to full) {
            if (sessions(mask) != INF) {
                for (i <- 0 until n) {
                    if ((mask & (1 << i)) == 0) {
                        val nm = mask | (1 << i)
                        var ns = 0
                        var nu = 0
                        if (used(mask) + tasks(i) <= sessionTime) {
                            ns = sessions(mask)
                            nu = used(mask) + tasks(i)
                        } else {
                            ns = sessions(mask) + 1
                            nu = tasks(i)
                        }
                        if (ns < sessions(nm) || (ns == sessions(nm) && nu < used(nm))) {
                            sessions(nm) = ns
                            used(nm) = nu
                        }
                    }
                }
            }
        }
        sessions(full)
    }
}
