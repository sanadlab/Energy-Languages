class Solution {
    private $root;
    private $stream;
    private $maxLen;

    function __construct($words = array()) {
        $this->root = array();
        $this->stream = array();
        $this->maxLen = 0;
        foreach ($words as $w) {
            $node = &$this->root;
            for ($i = strlen($w) - 1; $i >= 0; $i--) {
                $ch = $w[$i];
                if (!isset($node[$ch])) $node[$ch] = array();
                $node = &$node[$ch];
            }
            $node['$'] = true;
            if (strlen($w) > $this->maxLen) $this->maxLen = strlen($w);
            unset($node);
        }
    }

    function query($letter) {
        $this->stream[] = $letter;
        $node = $this->root;
        $n = count($this->stream);
        for ($step = 0; $step < $this->maxLen && $step < $n; $step++) {
            $ch = $this->stream[$n - 1 - $step];
            if (!isset($node[$ch])) return false;
            $node = $node[$ch];
            if (isset($node['$']) && $node['$']) return true;
        }
        return false;
    }
}
