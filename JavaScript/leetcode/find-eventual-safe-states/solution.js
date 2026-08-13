/**
 * @param {number[][]} graph
 * @return {number[]}
 */
var eventualSafeNodes = function(graph) {
    const n = graph.length;
    const WHITE = 0, GRAY = 1, BLACK = 2;
    const color = new Array(n).fill(WHITE);

    function dfs(node) {
        if (color[node] !== WHITE) {
            return color[node] === BLACK;
        }
        color[node] = GRAY;
        for (const nei of graph[node]) {
            if (color[nei] === BLACK) continue;
            if (color[nei] === GRAY || !dfs(nei)) {
                return false;
            }
        }
        color[node] = BLACK;
        return true;
    }

    const res = [];
    for (let i = 0; i < n; i++) {
        if (dfs(i)) res.push(i);
    }
    return res;
};