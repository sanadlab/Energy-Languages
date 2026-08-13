class Solution {

    /**
     * @param String $s
     * @param Integer $k
     * @return String
     */
    function licenseKeyFormatting($s, $k) {
        // Remove all dashes and convert to uppercase
        $s = strtoupper(str_replace('-', '', $s));
        $len = strlen($s);
        $firstGroupLen = $len % $k;
        if ($firstGroupLen == 0 && $len > 0) {
            $firstGroupLen = $k;
        }
        
        $result = substr($s, 0, $firstGroupLen);
        for ($i = $firstGroupLen; $i < $len; $i += $k) {
            $result .= '-' . substr($s, $i, $k);
        }
        
        return $result;
    }
}