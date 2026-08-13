class Solution {
    public function diStringMatch(string $s): array {
        $n = strlen($s);
        $low = 0;
        $high = $n;
        $perm = [];
        for ($i = 0; $i < $n; $i++) {
            if ($s[$i] == 'I') {
                $perm[] = $low;
                $low++;
            } else {
                $perm[] = $high;
                $high--;
            }
        }
        $perm[] = $low;
        return $perm;
    }
}