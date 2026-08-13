pub struct Solution;

impl Solution {
    pub fn sort_by_bits(mut arr: Vec<i32>) -> Vec<i32> {
        arr.sort_by(|&a, &b| {
            let pa = (a as u32).count_ones();
            let pb = (b as u32).count_ones();
            pa.cmp(&pb).then(a.cmp(&b))
        });
        arr
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::sort_by_bits(vec![1,2,3,4,5]);
}
