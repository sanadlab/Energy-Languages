class CustomStack {
    private $maxSize;
    private $stk;
    private $inc;
    function __construct($maxSize) {
        $this->maxSize = $maxSize;
        $this->stk = array();
        $this->inc = array();
    }
    function push($x) {
        if (count($this->stk) < $this->maxSize) {
            $this->stk[] = $x;
            $this->inc[] = 0;
        }
    }
    function pop() {
        if (count($this->stk) == 0) return -1;
        $i = count($this->stk) - 1;
        $v = $this->stk[$i] + $this->inc[$i];
        if ($i > 0) $this->inc[$i - 1] += $this->inc[$i];
        array_pop($this->stk);
        array_pop($this->inc);
        return $v;
    }
    function increment($k, $val) {
        $i = min($k, count($this->stk)) - 1;
        if ($i >= 0) $this->inc[$i] += $val;
    }
}
