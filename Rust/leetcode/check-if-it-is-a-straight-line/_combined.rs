pub struct Solution;

impl Solution {
    pub fn check_straight_line(coordinates: Vec<Vec<i32>>) -> bool {
        let (x0, y0) = (coordinates[0][0], coordinates[0][1]);
        let (x1, y1) = (coordinates[1][0], coordinates[1][1]);
        let dx = x1 - x0;
        let dy = y1 - y0;

        for i in 2..coordinates.len() {
            let (x, y) = (coordinates[i][0], coordinates[i][1]);
            // Check cross product (dx, dy) x (x - x0, y - y0) == 0
            if dy * (x - x0) != dx * (y - y0) {
                return false;
            }
        }
        true
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::check_straight_line(vec![vec![1,2],vec![3,4]]);
}
