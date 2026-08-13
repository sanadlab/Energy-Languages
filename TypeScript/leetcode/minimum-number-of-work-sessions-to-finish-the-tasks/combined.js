"use strict";
function minSessions(tasks, sessionTime) {
    const n = tasks.length;
    const full = (1 << n) - 1;
    const INF = 1e9;
    const sessions = new Array(1 << n).fill(INF);
    const used = new Array(1 << n).fill(0);
    sessions[0] = 1;
    for (let mask = 0; mask <= full; mask++) {
        if (sessions[mask] === INF)
            continue;
        for (let i = 0; i < n; i++) {
            if (mask & (1 << i))
                continue;
            const nm = mask | (1 << i);
            let ns, nu;
            if (used[mask] + tasks[i] <= sessionTime) {
                ns = sessions[mask];
                nu = used[mask] + tasks[i];
            }
            else {
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
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minSessions([1,2,3,4,5], 20)');
}
catch (_e) {
    _lc_test_result = eval('minSessions([1,2,3,4,5], 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
