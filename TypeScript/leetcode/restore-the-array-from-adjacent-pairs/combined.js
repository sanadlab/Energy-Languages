"use strict";
function restoreArray(adjacentPairs) {
    const adj = new Map();
    for (const [u, v] of adjacentPairs) {
        if (!adj.has(u))
            adj.set(u, []);
        if (!adj.has(v))
            adj.set(v, []);
        adj.get(u).push(v);
        adj.get(v).push(u);
    }
    const n = adjacentPairs.length + 1;
    let start = adjacentPairs.length > 0 ? adjacentPairs[0][0] : 0;
    for (const [node, nbrs] of adj) {
        if (nbrs.length === 1) {
            start = node;
            break;
        }
    }
    const res = [start];
    let prev = start, cur = start, hasPrev = false;
    while (res.length < n) {
        let nxt = null;
        const nbrs = adj.get(cur);
        if (nbrs) {
            for (const x of nbrs) {
                if (!hasPrev || x !== prev) {
                    nxt = x;
                    break;
                }
            }
        }
        if (nxt === null)
            break;
        res.push(nxt);
        prev = cur;
        hasPrev = true;
        cur = nxt;
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().restoreArray([[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('restoreArray([[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
