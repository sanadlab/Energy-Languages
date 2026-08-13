class Solution {
    public function countCollisions(string $directions) {
        $n = strlen($directions);
        $countS = 0;
        for ($i = 0; $i < $n; $i++) {
            if ($directions[$i] == 'S') {
                $countS++;
            }
        }
        
        $prefix = 0;
        for ($i = 0; $i < $n; $i++) {
            if ($directions[$i] == 'L') {
                $prefix++;
            } else {
                break;
            }
        }
        
        $suffix = 0;
        for ($i = $n - 1; $i >= 0; $i--) {
            if ($directions[$i] == 'R') {
                $suffix++;
            } else {
                break;
            }
        }
        
        return ($n - $countS) - ($prefix + $suffix);
    }
}