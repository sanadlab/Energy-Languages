pub struct Solution;

impl Solution {
    pub fn next_beautiful_number(n: i32) -> i32 {
        let mut x = n + 1;
        loop {
            let mut cnt = [0i32; 10];
            let mut t = x;
            while t > 0 {
                cnt[(t % 10) as usize] += 1;
                t /= 10;
            }
            let mut ok = true;
            for d in 0..10 {
                if cnt[d] != 0 && cnt[d] != d as i32 {
                    ok = false;
                    break;
                }
            }
            if ok {
                return x;
            }
            x += 1;
        }
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::next_beautiful_number(20);
}
