class Solution {

    /**
     * @param ListNode $head
     * @param Integer[] $nums
     * @return Integer
     */
    function numComponents($head, $nums) {
        $set = array();
        foreach ($nums as $n) { $set[$n] = true; }
        $count = 0;
        $prev = false;
        while ($head !== null) {
            $cur = isset($set[$head->val]);
            if ($cur && !$prev) $count++;
            $prev = $cur;
            $head = $head->next;
        }
        return $count;
    }
}
