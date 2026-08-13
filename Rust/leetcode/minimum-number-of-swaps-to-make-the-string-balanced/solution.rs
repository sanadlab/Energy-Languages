impl Solution {
    pub fn min_swaps(s: String) -> i32 {
        let mut open = 0;
        for c in s.chars() {
            if c == '[' {
                open += 1;
            } else if open > 0 {
                open -= 1;
            }
        }
        (open + 1) / 2
    }
}
