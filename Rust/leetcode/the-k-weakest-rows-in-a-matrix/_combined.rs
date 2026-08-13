pub struct Solution;

impl Solution {
    pub fn k_weakest_rows(mat: Vec<Vec<i32>>, k: i32) -> Vec<i32> {
        let mut rows: Vec<(i32, i32)> = mat.iter().enumerate()
            .map(|(i, row)| (row.iter().filter(|&&v| v == 1).count() as i32, i as i32))
            .collect();
        rows.sort();
        let lim = (k as usize).min(rows.len());
        rows.into_iter().take(lim).map(|(_, i)| i).collect()
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::k_weakest_rows(vec![vec![1,2],vec![3,4]], 20);
}
