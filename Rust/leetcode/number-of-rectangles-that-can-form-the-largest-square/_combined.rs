pub struct Solution;

impl Solution {
    pub fn count_good_rectangles(rectangles: Vec<Vec<i32>>) -> i32 {
        let mut max_len = 0;
        let mut count = 0;
        for r in &rectangles {
            let side = r[0].min(r[1]);
            if side > max_len {
                max_len = side;
                count = 1;
            } else if side == max_len {
                count += 1;
            }
        }
        count
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::count_good_rectangles(vec![vec![1,2],vec![3,4]]);
}
