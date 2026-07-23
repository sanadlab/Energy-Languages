// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::array_strings_are_equal(vec![String::from("a"),String::from("b"),String::from("c")], vec![String::from("a"),String::from("b"),String::from("c")]);
}
