pub struct Solution;

impl Solution {
    pub fn min_days(bloom_day: Vec<i32>, m: i32, k: i32) -> i32 {
        let n = bloom_day.len() as i64;
        if (m as i64) * (k as i64) > n {
            return -1;
        }
        let can_make = |day: i32| -> bool {
            let mut bouquets = 0;
            let mut flowers = 0;
            for &b in &bloom_day {
                if b <= day {
                    flowers += 1;
                    if flowers == k {
                        bouquets += 1;
                        flowers = 0;
                    }
                } else {
                    flowers = 0;
                }
            }
            bouquets >= m
        };
        let mut lo = *bloom_day.iter().min().unwrap();
        let mut hi = *bloom_day.iter().max().unwrap();
        while lo < hi {
            let mid = lo + (hi - lo) / 2;
            if can_make(mid) {
                hi = mid;
            } else {
                lo = mid + 1;
            }
        }
        lo
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_days(vec![1,2,3,4,5], 20, 20);
}
