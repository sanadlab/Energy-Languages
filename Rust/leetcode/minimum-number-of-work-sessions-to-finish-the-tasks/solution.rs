impl Solution {
    pub fn min_sessions(tasks: Vec<i32>, session_time: i32) -> i32 {
        let n = tasks.len();
        let full = (1usize << n) - 1;
        const INF: i32 = 1_000_000_000;
        let mut sessions = vec![INF; 1 << n];
        let mut used = vec![0i32; 1 << n];
        sessions[0] = 1;
        for mask in 0..=full {
            if sessions[mask] == INF {
                continue;
            }
            for i in 0..n {
                if mask & (1 << i) != 0 {
                    continue;
                }
                let nm = mask | (1 << i);
                let (ns, nu) = if used[mask] + tasks[i] <= session_time {
                    (sessions[mask], used[mask] + tasks[i])
                } else {
                    (sessions[mask] + 1, tasks[i])
                };
                if ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm]) {
                    sessions[nm] = ns;
                    used[nm] = nu;
                }
            }
        }
        sessions[full]
    }
}
