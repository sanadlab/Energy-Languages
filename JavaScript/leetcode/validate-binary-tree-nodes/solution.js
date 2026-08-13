var validateBinaryTreeNodes = function(n, leftChild, rightChild) {
    const m = Math.min(leftChild.length, rightChild.length);
    const indeg = new Array(n).fill(0);
    for (let i = 0; i < m; i++) {
        for (const c of [leftChild[i], rightChild[i]]) {
            if (c !== -1) {
                if (c < 0 || c >= n) return false;
                if (++indeg[c] > 1) return false;
            }
        }
    }
    let root = -1;
    for (let i = 0; i < n; i++) {
        if (indeg[i] === 0) {
            if (root !== -1) return false;
            root = i;
        }
    }
    if (root === -1) return false;
    const visited = new Array(n).fill(false);
    const stack = [root];
    let count = 0;
    while (stack.length) {
        const node = stack.pop();
        if (visited[node]) return false;
        visited[node] = true;
        count++;
        if (node < m) {
            for (const c of [leftChild[node], rightChild[node]]) {
                if (c !== -1) stack.push(c);
            }
        }
    }
    return count === n;
};
