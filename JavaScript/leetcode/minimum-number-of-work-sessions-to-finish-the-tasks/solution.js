var minSessions = function(tasks, sessionTime) {
    const n = tasks.length;
    const full = (1 << n) - 1;
    const INF = 1e9;
    const sessions = new Array(1 << n).fill(INF);
    const used = new Array(1 << n).fill(0);
    sessions[0] = 1;
    for (let mask = 0; mask <= full; mask++) {
        if (sessions[mask] === INF) continue;
        for (let i = 0; i < n; i++) {
            if (mask & (1 << i)) continue;
            const nm = mask | (1 << i);
            let ns, nu;
            if (used[mask] + tasks[i] <= sessionTime) {
                ns = sessions[mask];
                nu = used[mask] + tasks[i];
            } else {
                ns = sessions[mask] + 1;
                nu = tasks[i];
            }
            if (ns < sessions[nm] || (ns === sessions[nm] && nu < used[nm])) {
                sessions[nm] = ns;
                used[nm] = nu;
            }
        }
    }
    return sessions[full];
};
