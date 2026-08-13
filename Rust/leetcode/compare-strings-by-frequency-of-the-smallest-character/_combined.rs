pub struct Solution;

impl Solution {
    pub fn num_smaller_by_frequency(queries: Vec<String>, words: Vec<String>) -> Vec<i32> {
        fn f(s: &str) -> i32 {
            let mut mn = b'z';
            let mut cnt = 0;
            for &c in s.as_bytes() {
                if c < mn {
                    mn = c;
                    cnt = 1;
                } else if c == mn {
                    cnt += 1;
                }
            }
            cnt
        }
        let word_f: Vec<i32> = words.iter().map(|w| f(w)).collect();
        queries
            .iter()
            .map(|q| {
                let fq = f(q);
                word_f.iter().filter(|&&v| v > fq).count() as i32
            })
            .collect()
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::num_smaller_by_frequency(vec![String::from("a"),String::from("b"),String::from("c")], vec![String::from("a"),String::from("b"),String::from("c")]);
}
