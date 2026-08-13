pub struct Solution;

impl Solution {
    pub fn max_run_time(n: i32, batteries: Vec<i32>) -> i64 {
        let n = n as i64;
        let sum: i64 = batteries.iter().map(|&b| b as i64).sum();
        let mut lo: i64 = 0;
        let mut hi: i64 = sum / n;
        while lo < hi {
            let mid = (lo + hi + 1) / 2;
            let mut avail: i64 = 0;
            for &b in &batteries {
                avail += (b as i64).min(mid);
            }
            if avail >= n * mid { lo = mid; } else { hi = mid - 1; }
        }
        lo
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::max_run_time(20, vec![1,2,3,4,5]);
}
