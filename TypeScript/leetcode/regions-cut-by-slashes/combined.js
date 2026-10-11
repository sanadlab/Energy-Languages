"use strict";
function regionsBySlashes(grid) {
    const n = grid.length;
    const total = 4 * n * n;
    const parent = new Int32Array(total);
    const size = new Int32Array(total);
    let regions = total;
    for (let i = 0; i < total; i++) {
        parent[i] = i;
        size[i] = 1;
    }
    function find(x) {
        while (parent[x] !== x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }
    function union(a, b) {
        let rootA = find(a);
        let rootB = find(b);
        if (rootA === rootB)
            return;
        if (size[rootA] < size[rootB]) {
            [rootA, rootB] = [rootB, rootA];
        }
        parent[rootB] = rootA;
        size[rootA] += size[rootB];
        regions--;
    }
    for (let row = 0; row < n; row++) {
        for (let col = 0; col < n; col++) {
            // Each cell has four triangles: top, right, bottom, left.
            const base = 4 * (row * n + col);
            const char = grid[row][col];
            if (char !== "/") {
                union(base, base + 1);
                union(base + 2, base + 3);
            }
            if (char !== "\\") {
                union(base, base + 3);
                union(base + 1, base + 2);
            }
            if (col + 1 < n) {
                union(base + 1, base + 4 + 3);
            }
            if (row + 1 < n) {
                union(base + 2, base + 4 * n);
            }
        }
    }
    return regions;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().regionsBySlashes(["a","b","c"])');
}
catch (_e) {
    _lc_test_result = eval('regionsBySlashes(["a","b","c"])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
