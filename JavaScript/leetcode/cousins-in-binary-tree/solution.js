/**
 * @param {TreeNode} root
 * @param {number} x
 * @param {number} y
 * @return {boolean}
 */
var isCousins = function(root, x, y) {
    let dx = -1, dy = -1, px = null, py = null;
    const dfs = (node, parent, depth) => {
        if (!node) return;
        if (node.val === x) { dx = depth; px = parent; }
        if (node.val === y) { dy = depth; py = parent; }
        dfs(node.left, node, depth + 1);
        dfs(node.right, node, depth + 1);
    };
    dfs(root, null, 0);
    return dx === dy && px !== py;
};
