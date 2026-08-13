"use strict";
function getCoprimes(nums, edges) {
    const n = nums.length;
    const ans = new Array(n).fill(-1);
    const adj = Array.from({ length: n }, () => []);
    for (const e of edges) {
        if (!Array.isArray(e) || e.length < 2)
            continue;
        const u = e[0], v = e[1];
        if (u >= 0 && u < n && v >= 0 && v < n) {
            adj[u].push(v);
            adj[v].push(u);
        }
    }
    const gcd = (a, b) => {
        while (b !== 0) {
            const t = b;
            b = a % b;
            a = t;
        }
        return a;
    };
    // For each value 1..50, values coprime with it.
    const coprime = Array.from({ length: 51 }, () => []);
    for (let a = 1; a <= 50; a++)
        for (let b = 1; b <= 50; b++)
            if (gcd(a, b) === 1)
                coprime[a].push(b);
    // Ancestor stacks indexed by VALUE (size 51).
    const depthStack = Array.from({ length: 51 }, () => []);
    const nodeStack = Array.from({ length: 51 }, () => []);
    if (n === 0)
        return ans;
    // Iterative DFS with enter/exit markers.
    const stack = [[0, -1, 0, false]];
    while (stack.length > 0) {
        const [node, parent, depth, processed] = stack.pop();
        const val = nums[node];
        if (processed) {
            depthStack[val].pop();
            nodeStack[val].pop();
            continue;
        }
        let bestDepth = -1;
        let bestNode = -1;
        for (const cv of coprime[val]) {
            const ds = depthStack[cv];
            if (ds.length > 0 && ds[ds.length - 1] > bestDepth) {
                bestDepth = ds[ds.length - 1];
                bestNode = nodeStack[cv][nodeStack[cv].length - 1];
            }
        }
        ans[node] = bestNode;
        stack.push([node, parent, depth, true]);
        depthStack[val].push(depth);
        nodeStack[val].push(node);
        for (const nb of adj[node]) {
            if (nb !== parent)
                stack.push([nb, node, depth + 1, false]);
        }
    }
    return ans;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().getCoprimes([1,2,3,4,5], [[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('getCoprimes([1,2,3,4,5], [[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
