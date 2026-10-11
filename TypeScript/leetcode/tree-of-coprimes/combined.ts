function getCoprimes(nums: number[], edges: number[][]): number[] {
    const n = nums.length;
    const graph: number[][] = Array.from({ length: n }, () => []);

    for (const [u, v] of edges) {
        graph[u].push(v);
        graph[v].push(u);
    }

    const gcd = (a: number, b: number): number => {
        while (b !== 0) {
            const remainder = a % b;
            a = b;
            b = remainder;
        }
        return a;
    };

    const coprimes: number[][] = Array.from({ length: 51 }, () => []);
    for (let a = 1; a <= 50; a++) {
        for (let b = 1; b <= 50; b++) {
            if (gcd(a, b) === 1) coprimes[a].push(b);
        }
    }

    const answer = new Array<number>(n).fill(-1);
    const closest = new Int32Array(51).fill(-1);
    const previous = new Int32Array(n);
    const parent = new Int32Array(n).fill(-1);
    const depth = new Int32Array(n);

    // Nonnegative events enter a node; complemented events leave it.
    const stack: number[] = [0];

    while (stack.length > 0) {
        const event = stack.pop()!;

        if (event < 0) {
            const node = ~event;
            closest[nums[node]] = previous[node];
            continue;
        }

        const node = event;
        const value = nums[node];
        let bestDepth = -1;

        // Query before inserting this node, since it is not its own ancestor.
        for (const otherValue of coprimes[value]) {
            const ancestor = closest[otherValue];
            if (ancestor !== -1 && depth[ancestor] > bestDepth) {
                bestDepth = depth[ancestor];
                answer[node] = ancestor;
            }
        }

        previous[node] = closest[value];
        closest[value] = node;
        stack.push(~node);

        for (const child of graph[node]) {
            if (child === parent[node]) continue;
            parent[child] = node;
            depth[child] = depth[node] + 1;
            stack.push(child);
        }
    }

    return answer;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().getCoprimes([1,2,3,4,5], [[1,2],[3,4]])'); }
catch (_e) { _lc_test_result = eval('getCoprimes([1,2,3,4,5], [[1,2],[3,4]])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
