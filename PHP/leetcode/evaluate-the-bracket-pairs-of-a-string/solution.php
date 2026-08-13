class Solution {
    public function evaluate($s, $knowledge) {
        $map = [];
        foreach ($knowledge as $pair) {
            $key = $pair[0];
            $value = $pair[1];
            $map[$key] = $value;
        }

        $result = '';
        $i = 0;
        $n = strlen($s);

        while ($i < $n) {
            if ($s[$i] === '(') {
                $j = $i + 1;
                while ($j < $n && $s[$j] !== ')') {
                    $j++;
                }
                if ($j < $n) {
                    $key = substr($s, $i + 1, $j - $i - 1);
                    $result .= array_key_exists($key, $map) ? $map[$key] : '?';
                    $i = $j + 1;
                } else {
                    $result .= '?';
                    $i = $n;
                }
            } else {
                $result .= $s[$i];
                $i++;
            }
        }

        return $result;
    }
}