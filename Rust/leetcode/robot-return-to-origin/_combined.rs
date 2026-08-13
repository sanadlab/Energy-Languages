pub struct Solution;

impl Solution {
    pub fn judge_circle(moves: String) -> bool {
        let mut x = 0i32;
        let mut y = 0i32;
        for c in moves.chars() {
            match c {
                'U' => y += 1,
                'D' => y -= 1,
                'L' => x -= 1,
                'R' => x += 1,
                _ => {}
            }
        }
        x == 0 && y == 0
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::judge_circle(String::from("abcde"));
}
