pub struct Solution;

impl Solution {
    pub fn spiral_matrix_iii(rows: i32, cols: i32, r_start: i32, c_start: i32) -> Vec<Vec<i32>> {
        let total = rows * cols;
        let mut res: Vec<Vec<i32>> = Vec::new();
        let mut r = r_start;
        let mut c = c_start;
        if r >= 0 && r < rows && c >= 0 && c < cols {
            res.push(vec![r, c]);
        }
        let dr = [0, 1, 0, -1];
        let dc = [1, 0, -1, 0];
        let mut step = 1;
        let mut d = 0usize;
        while (res.len() as i32) < total {
            for _ in 0..2 {
                for _ in 0..step {
                    r += dr[d % 4];
                    c += dc[d % 4];
                    if r >= 0 && r < rows && c >= 0 && c < cols {
                        res.push(vec![r, c]);
                    }
                }
                d += 1;
            }
            step += 1;
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::spiral_matrix_iii(20, 20, 20, 20);
}
