var minDepth = function(root) {
    if (!root) return 0;
    let queue = [root];
    let depth = 1;
    while (queue.length) {
        const sz = queue.length;
        const next = [];
        for (let i = 0; i < sz; i++) {
            const node = queue[i];
            if (!node.left && !node.right) return depth;
            if (node.left) next.push(node.left);
            if (node.right) next.push(node.right);
        }
        queue = next;
        depth++;
    }
    return depth;
};
