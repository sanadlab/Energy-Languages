class Solution {
    private $m;
    private $k;
    private $stream;

    function __construct($m = 0, $k = 0) {
        $this->m = $m;
        $this->k = $k;
        $this->stream = [];
    }

    function addElement($num) {
        $this->stream[] = $num;
    }

    function calculateMKAverage() {
        $n = count($this->stream);
        if ($n < $this->m) return -1;
        $last = array_slice($this->stream, $n - $this->m);
        sort($last);
        $sum = 0;
        $cnt = 0;
        for ($i = $this->k; $i < $this->m - $this->k; $i++) {
            $sum += $last[$i];
            $cnt++;
        }
        if ($cnt == 0) return 0;
        return intdiv($sum, $cnt);
    }
}
