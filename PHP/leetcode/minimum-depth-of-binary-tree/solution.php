class Solution {
    function minDepth($root) {
        if ($root === null) return 0;
        $queue = array($root);
        $depth = 1;
        while (!empty($queue)) {
            $next = array();
            foreach ($queue as $node) {
                if ($node->left === null && $node->right === null) return $depth;
                if ($node->left !== null) $next[] = $node->left;
                if ($node->right !== null) $next[] = $node->right;
            }
            $queue = $next;
            $depth++;
        }
        return $depth;
    }
}
