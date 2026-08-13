class Solution {
    public function isCousins($root, $x, $y) {
        $queue = new SplQueue();
        $queue->enqueue([$root, null, 0]);
        $depthX = null;
        $parentX = null;
        $depthY = null;
        $parentY = null;
        
        while (!$queue->isEmpty()) {
            $node = $queue->dequeue();
            $currentNode = $node[0];
            $currentParent = $node[1];
            $currentDepth = $node[2];
            
            if ($currentNode->val == $x) {
                $depthX = $currentDepth;
                $parentX = $currentParent;
            }
            if ($currentNode->val == $y) {
                $depthY = $currentDepth;
                $parentY = $currentParent;
            }
            
            if ($depthX !== null && $depthY !== null) {
                break;
            }
            
            if ($currentNode->left) {
                $queue->enqueue([$currentNode->left, $currentNode, $currentDepth + 1]);
            }
            if ($currentNode->right) {
                $queue->enqueue([$currentNode->right, $currentNode, $currentDepth + 1]);
            }
        }
        
        return ($depthX === $depthY && $parentX !== $parentY);
    }
}