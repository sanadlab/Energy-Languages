class TreeNode {
    constructor(left, right) {
        this.left = left;
        this.right = right;
    }
}
function makeTree(depth) {
    if (depth === 0) {
        return new TreeNode(null, null);
    }
    const nextDepth = depth - 1;
    return new TreeNode(makeTree(nextDepth), makeTree(nextDepth));
}
function itemCheck(node) {
    if (node.left === null) {
        return 1;
    }
    return 1 + itemCheck(node.left) + itemCheck(node.right);
}
function main() {
    const n = Number.parseInt(process.argv[2], 10);
    const minDepth = 4;
    const maxDepth = Math.max(minDepth + 2, n);
    const stretchDepth = maxDepth + 1;
    const stretchTree = makeTree(stretchDepth);
    console.log(`stretch tree of depth ${stretchDepth}\t check: ${itemCheck(stretchTree)}`);
    const longLivedTree = makeTree(maxDepth);
    for (let depth = minDepth; depth <= maxDepth; depth += 2) {
        const iterations = 2 ** (maxDepth - depth + minDepth);
        let check = 0;
        for (let i = 0; i < iterations; i++) {
            check += itemCheck(makeTree(depth));
        }
        console.log(`${iterations}\t trees of depth ${depth}\t check: ${check}`);
    }
    console.log(`long lived tree of depth ${maxDepth}\t check: ${itemCheck(longLivedTree)}`);
}
main();
