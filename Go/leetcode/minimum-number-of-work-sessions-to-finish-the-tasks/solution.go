func minSessions(tasks []int, sessionTime int) int {
    n := len(tasks)
    full := (1 << n) - 1
    const INF = 1000000000
    sessions := make([]int, 1<<n)
    used := make([]int, 1<<n)
    for i := range sessions {
        sessions[i] = INF
    }
    sessions[0] = 1
    for mask := 0; mask <= full; mask++ {
        if sessions[mask] == INF {
            continue
        }
        for i := 0; i < n; i++ {
            if mask&(1<<i) != 0 {
                continue
            }
            nm := mask | (1 << i)
            var ns, nu int
            if used[mask]+tasks[i] <= sessionTime {
                ns = sessions[mask]
                nu = used[mask] + tasks[i]
            } else {
                ns = sessions[mask] + 1
                nu = tasks[i]
            }
            if ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm]) {
                sessions[nm] = ns
                used[nm] = nu
            }
        }
    }
    return sessions[full]
}
