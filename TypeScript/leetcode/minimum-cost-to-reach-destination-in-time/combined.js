"use strict";
function minCost(maxTime, edges, passingFees) {
    const n = passingFees.length;
    const INF = 1 << 29;
    const adj = Array.from({ length: n }, () => []);
    for (const e of edges) {
        if (e.length < 3)
            continue;
        const x = e[0], y = e[1], w = e[2];
        if (x < 0 || x >= n || y < 0 || y >= n || w < 0)
            continue;
        adj[x].push([y, w]);
        adj[y].push([x, w]);
    }
    const dp = Array.from({ length: maxTime + 1 }, () => new Array(n).fill(INF));
    dp[0][0] = passingFees[0];
    let ans = INF;
    for (let t = 0; t <= maxTime; t++) {
        for (let u = 0; u < n; u++) {
            const cur = dp[t][u];
            if (cur >= INF)
                continue;
            if (u === n - 1)
                ans = Math.min(ans, cur);
            for (const [v, w] of adj[u]) {
                const nt = t + w;
                if (nt <= maxTime && cur + passingFees[v] < dp[nt][v])
                    dp[nt][v] = cur + passingFees[v];
            }
        }
    }
    return ans >= INF ? -1 : ans;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minCost(20, [[1,2],[3,4]], [1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('minCost(20, [[1,2],[3,4]], [1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
