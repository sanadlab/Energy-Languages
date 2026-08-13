class Solution {
    function average($salary) {
        $mn = $salary[0]; $mx = $salary[0]; $sum = 0;
        foreach ($salary as $s) { $sum += $s; if ($s < $mn) $mn = $s; if ($s > $mx) $mx = $s; }
        return ($sum - $mn - $mx) / (count($salary) - 2);
    }
}
