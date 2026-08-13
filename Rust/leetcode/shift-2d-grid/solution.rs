impl Solution {
    pub fn shift_grid(grid: Vec<Vec<i32>>, k: i32) -> Vec<Vec<i32>> {
        let m = grid.len();
        if m == 0 {
            return grid;
        }
        let n = grid[0].len();
        if n == 0 {
            return grid;
        }
        let total = m * n;
        let k = (k as usize) % total;
        let mut flat = Vec::with_capacity(total);
        for row in &grid {
            for &num in row {
                flat.push(num);
            }
        }
        let mut res = vec![vec![0i32; n]; m];
        for idx in 0..total {
            let np = (idx + k) % total;
            res[np / n][np % n] = flat[idx];
        }
        res
    }
}
