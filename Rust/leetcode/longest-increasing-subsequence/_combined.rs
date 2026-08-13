pub struct Solution;

impl Solution {
    pub fn length_of_lis(nums: Vec<i32>) -> i32 {
        let mut tails: Vec<i32> = Vec::new();
        for x in nums {
            match tails.binary_search(&x) {
                Ok(_) => {}
                Err(pos) => {
                    if pos == tails.len() {
                        tails.push(x);
                    } else {
                        tails[pos] = x;
                    }
                }
            }
        }
        tails.len() as i32
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::length_of_lis(vec![1,2,3,4,5]);
}
