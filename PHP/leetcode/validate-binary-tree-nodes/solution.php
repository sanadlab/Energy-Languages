class Solution {

    /**
     * @param Integer $n
     * @param Integer[] $leftChild
     * @param Integer[] $rightChild
     * @return Boolean
     */
    function validateBinaryTreeNodes($n, $leftChild, $rightChild) {
        // Each node except root has exactly one parent.
        // So count parents for each node.
        $parentCount = array_fill(0, $n, 0);

        for ($i = 0; $i < $n; $i++) {
            if ($leftChild[$i] != -1) {
                $parentCount[$leftChild[$i]]++;
                // If a node has more than one parent, invalid
                if ($parentCount[$leftChild[$i]] > 1) return false;
            }
            if ($rightChild[$i] != -1) {
                $parentCount[$rightChild[$i]]++;
                if ($parentCount[$rightChild[$i]] > 1) return false;
            }
        }

        // Find the root (node with no parent)
        $root = -1;
        for ($i = 0; $i < $n; $i++) {
            if ($parentCount[$i] == 0) {
                if ($root != -1) {
                    // More than one root found
                    return false;
                }
                $root = $i;
            }
        }

        // If no root found, invalid
        if ($root == -1) return false;

        // Check if all nodes are reachable from root (no disconnected parts)
        $visited = array_fill(0, $n, false);
        $stack = [$root];
        while (!empty($stack)) {
            $node = array_pop($stack);
            if ($visited[$node]) continue;
            $visited[$node] = true;
            if ($leftChild[$node] != -1) $stack[] = $leftChild[$node];
            if ($rightChild[$node] != -1) $stack[] = $rightChild[$node];
        }

        // If any node is not visited, means disconnected or cycle
        for ($i = 0; $i < $n; $i++) {
            if (!$visited[$i]) return false;
        }

        return true;
    }
}