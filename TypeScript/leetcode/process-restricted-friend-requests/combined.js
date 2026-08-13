"use strict";
function friendRequests(n, restrictions, requests) {
    const parent = [];
    for (let i = 0; i < n; i++)
        parent[i] = i;
    const find = (x) => {
        while (parent[x] !== x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    };
    const res = [];
    for (const req of requests) {
        const u = req[0], v = req[1];
        const pu = find(u), pv = find(v);
        if (pu === pv) {
            res.push(true);
            continue;
        }
        let ok = true;
        for (const r of restrictions) {
            const px = find(r[0]), py = find(r[1]);
            if ((px === pu && py === pv) || (px === pv && py === pu)) {
                ok = false;
                break;
            }
        }
        if (ok) {
            parent[pu] = pv;
            res.push(true);
        }
        else
            res.push(false);
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().friendRequests(20, [[1,2],[3,4]], [[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('friendRequests(20, [[1,2],[3,4]], [[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
