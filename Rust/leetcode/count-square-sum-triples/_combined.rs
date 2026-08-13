pub struct Solution;

impl Solution {
    pub fn count_triples(n: i32) -> i32 {
        let mut count = 0;
        for a in 1..=n {
            for b in 1..=n {
                let c2 = a * a + b * b;
                let c = (c2 as f64).sqrt().round() as i32;
                if c >= 1 && c <= n && c * c == c2 {
                    count += 1;
                }
            }
        }
        count
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::count_triples(20);
}
