pub struct Solution;

impl Solution {
    pub fn max_total_fruits(fruits: Vec<Vec<i32>>, start_pos: i32, k: i32) -> i32 {
        let cost = |pos_l: i32, pos_r: i32| -> i32 {
            if pos_r <= start_pos {
                start_pos - pos_l
            } else if pos_l >= start_pos {
                pos_r - start_pos
            } else {
                (pos_r - pos_l) + (start_pos - pos_l).min(pos_r - start_pos)
            }
        };
        let n = fruits.len();
        let mut best = 0i32;
        let mut total = 0i32;
        let mut i = 0usize;
        for j in 0..n {
            total += fruits[j][1];
            while i <= j && cost(fruits[i][0], fruits[j][0]) > k {
                total -= fruits[i][1];
                i += 1;
            }
            if i <= j && total > best {
                best = total;
            }
        }
        best
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::max_total_fruits(vec![vec![1,2],vec![3,4]], 20, 20);
}
