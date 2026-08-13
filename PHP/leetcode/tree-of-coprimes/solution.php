class Solution {

    private $nums;
    private $graph;
    private $ans;
    private $stack; // For each value 1..50, store stack of [node, depth]
    private $depth;

    function gcd($a, $b) {
        while ($b != 0) {
            $t = $b;
            $b = $a % $b;
            $a = $t;
        }
        return $a;
    }

    function dfs($node, $parent, $d) {
        $val = $this->nums[$node];
        $bestDepth = -1;
        $bestNode = -1;

        // Check all values 1..50 for coprime ancestors
        for ($v = 1; $v <= 50; $v++) {
            if ($this->stack[$v] && $this->gcd($val, $v) == 1) {
                $top = end($this->stack[$v]);
                if ($top[1] > $bestDepth) {
                    $bestDepth = $top[1];
                    $bestNode = $top[0];
                }
            }
        }

        $this->ans[$node] = $bestNode;

        // Push current node to stack of its value
        $this->stack[$val][] = [$node, $d];

        foreach ($this->graph[$node] as $child) {
            if ($child !== $parent) {
                $this->dfs($child, $node, $d + 1);
            }
        }

        // Pop current node from stack
        array_pop($this->stack[$val]);
    }

    /**
     * @param Integer[] $nums
     * @param Integer[][] $edges
     * @return Integer[]
     */
    function getCoprimes($nums, $edges) {
        $this->nums = $nums;
        $n = count($nums);
        $this->graph = array_fill(0, $n, []);
        foreach ($edges as $e) {
            $u = $e[0];
            $v = $e[1];
            $this->graph[$u][] = $v;
            $this->graph[$v][] = $u;
        }

        $this->ans = array_fill(0, $n, -1);
        // Initialize stacks for values 1..50
        $this->stack = array_fill(1, 50, []);
        $this->dfs(0, -1, 0);

        return $this->ans;
    }
}