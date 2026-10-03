class Solution {
    fun minSessions(tasks: IntArray, sessionTime: Int): Int {
        val n = tasks.size
        val full = (1 shl n) - 1
        val INF = Int.MAX_VALUE
        val sessions = IntArray(1 shl n) { INF }
        val used = IntArray(1 shl n)
        sessions[0] = 1
        for (mask in 0..full) {
            if (sessions[mask] == INF) continue
            for (i in 0 until n) {
                if (mask and (1 shl i) != 0) continue
                val nm = mask or (1 shl i)
                val ns: Int
                val nu: Int
                if (used[mask] + tasks[i] <= sessionTime) {
                    ns = sessions[mask]
                    nu = used[mask] + tasks[i]
                } else {
                    ns = sessions[mask] + 1
                    nu = tasks[i]
                }
                if (ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm])) {
                    sessions[nm] = ns
                    used[nm] = nu
                }
            }
        }
        return sessions[full]
    }
}
