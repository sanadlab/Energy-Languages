function minDepth(root: TreeNode | null): number {
    if (root === null) return 0;
    let queue: TreeNode[] = [root];
    let depth = 1;
    while (queue.length) {
        const next: TreeNode[] = [];
        for (const node of queue) {
            if (node.left === null && node.right === null) return depth;
            if (node.left !== null) next.push(node.left);
            if (node.right !== null) next.push(node.right);
        }
        queue = next;
        depth++;
    }
    return depth;
}
