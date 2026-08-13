"use strict";
function eventualSafeNodes(graph) {
    const n = graph.length;
    const rev = Array.from({ length: n }, () => []);
    const outdeg = new Array(n).fill(0);
    for (let u = 0; u < n; u++) {
        for (const v of graph[u]) {
            if (v >= 0 && v < n) {
                rev[v].push(u);
                outdeg[u]++;
            }
        }
    }
    const queue = [];
    for (let i = 0; i < n; i++)
        if (outdeg[i] === 0)
            queue.push(i);
    const safe = new Array(n).fill(false);
    let head = 0;
    while (head < queue.length) {
        const v = queue[head++];
        safe[v] = true;
        for (const u of rev[v]) {
            if (--outdeg[u] === 0)
                queue.push(u);
        }
    }
    const res = [];
    for (let i = 0; i < n; i++)
        if (safe[i])
            res.push(i);
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().eventualSafeNodes([[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('eventualSafeNodes([[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
