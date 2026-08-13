var getCoprimes = function(nums, edges) {
    const n = nums.length;

    // Build adjacency list for the tree
    const graph = Array.from({length: n}, () => []);
    for (const [u,v] of edges) {
        graph[u].push(v);
        graph[v].push(u);
    }

    // Precompute gcd for all pairs 1..50 to speed up coprime checks
    const MAX_VAL = 50;
    const gcdCache = Array.from({length: MAX_VAL+1}, () => Array(MAX_VAL+1).fill(0));
    function gcd(a,b) {
        if (b === 0) return a;
        return gcd(b, a % b);
    }
    for (let i=1; i<=MAX_VAL; i++) {
        for (let j=1; j<=MAX_VAL; j++) {
            gcdCache[i][j] = gcd(i,j);
        }
    }

    // For each value 1..50, maintain a stack of [node, depth] where this value appeared in the path
    // This helps us find closest ancestor with that value
    const valStacks = Array.from({length: MAX_VAL+1}, () => []);

    const ans = Array(n).fill(-1);
    const visited = Array(n).fill(false);

    // DFS from root 0, keep track of depth
    function dfs(node, depth) {
        visited[node] = true;
        const val = nums[node];

        // Find closest ancestor with coprime value
        // Check all values 1..50, if gcd(val, v) == 1 and valStacks[v] not empty,
        // candidate ancestor is the last node in valStacks[v]
        let closestAncestor = -1;
        let closestDepth = -1;
        for (let v=1; v<=MAX_VAL; v++) {
            if (gcdCache[val][v] === 1 && valStacks[v].length > 0) {
                const [ancNode, ancDepth] = valStacks[v][valStacks[v].length-1];
                if (ancDepth > closestDepth) {
                    closestDepth = ancDepth;
                    closestAncestor = ancNode;
                }
            }
        }
        ans[node] = closestAncestor;

        // Push current node's value to stack
        valStacks[val].push([node, depth]);

        // DFS children
        for (const nxt of graph[node]) {
            if (!visited[nxt]) {
                dfs(nxt, depth+1);
            }
        }

        // Pop current node's value from stack when backtracking
        valStacks[val].pop();
    }

    dfs(0, 0);
    return ans;
};