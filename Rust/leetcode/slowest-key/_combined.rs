pub struct Solution;

impl Solution {
    pub fn slowest_key(release_times: Vec<i32>, keys_pressed: String) -> char {
        let keys: Vec<char> = keys_pressed.chars().collect();
        let mut best = keys[0];
        let mut best_dur = release_times[0];
        for i in 1..release_times.len() {
            let dur = release_times[i] - release_times[i - 1];
            if dur > best_dur || (dur == best_dur && keys[i] > best) {
                best_dur = dur;
                best = keys[i];
            }
        }
        best
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::slowest_key(vec![1,2,3,4,5], String::from("abcde"));
}
