class Solution {
    private $rows;
    private $cols;
    function minDays($grid) {
        if (!isset($grid[0]) || !is_array($grid[0])) $grid = array($grid);
        $this->rows = count($grid);
        $this->cols = count($grid[0]);
        if ($this->countIslands($grid) != 1) return 0;
        for ($i = 0; $i < $this->rows; $i++) {
            for ($j = 0; $j < $this->cols; $j++) {
                if ($grid[$i][$j] == 1) {
                    $grid[$i][$j] = 0;
                    if ($this->countIslands($grid) != 1) { $grid[$i][$j] = 1; return 1; }
                    $grid[$i][$j] = 1;
                }
            }
        }
        return 2;
    }
    private function countIslands($grid) {
        $visited = array();
        for ($i = 0; $i < $this->rows; $i++) $visited[$i] = array_fill(0, $this->cols, false);
        $count = 0;
        for ($i = 0; $i < $this->rows; $i++) {
            for ($j = 0; $j < $this->cols; $j++) {
                if ($grid[$i][$j] == 1 && !$visited[$i][$j]) {
                    $count++;
                    $this->dfs($grid, $visited, $i, $j);
                }
            }
        }
        return $count;
    }
    private function dfs($grid, &$visited, $i, $j) {
        if ($i < 0 || $i >= $this->rows || $j < 0 || $j >= $this->cols || $grid[$i][$j] != 1 || $visited[$i][$j]) return;
        $visited[$i][$j] = true;
        $this->dfs($grid, $visited, $i+1, $j);
        $this->dfs($grid, $visited, $i-1, $j);
        $this->dfs($grid, $visited, $i, $j+1);
        $this->dfs($grid, $visited, $i, $j-1);
    }
}
