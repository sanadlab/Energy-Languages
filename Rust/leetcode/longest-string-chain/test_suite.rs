// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::longest_str_chain(vec![String::from("a"),String::from("b"),String::from("c")]);
}
