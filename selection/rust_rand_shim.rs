// Minimal `rand` shim for the crate-free arena rustc compile. LeetCode's Rust
// environment ships the `rand` crate; `rustc _combined.rs` (no Cargo, no
// external crates) does not, so a solution with `use rand::{thread_rng, Rng}`
// fails with `unresolved import rand`. This module covers the common
// `thread_rng().gen_range(a..b)` pattern. It is a DETERMINISTIC xorshift, not a
// real RNG — fine for perf measurement (correctness is the LeetCode oracle's
// job). Prepended only when solution.rs contains `use rand`.
mod rand {
    use std::cell::Cell;
    thread_local!(static S: Cell<u64> = Cell::new(0x2545F4914F6CDD1D));
    fn next() -> u64 { S.with(|s| { let mut x = s.get(); x ^= x << 13; x ^= x >> 7; x ^= x << 17; s.set(x); x }) }
    pub trait SampleRange<T> { fn sample(self) -> T; }
    impl SampleRange<usize> for std::ops::Range<usize> {
        fn sample(self) -> usize { let n = self.end.saturating_sub(self.start).max(1); self.start + (next() as usize) % n }
    }
    impl SampleRange<i32> for std::ops::Range<i32> {
        fn sample(self) -> i32 { let n = (self.end - self.start).max(1) as u64; self.start + (next() % n) as i32 }
    }
    impl SampleRange<i64> for std::ops::Range<i64> {
        fn sample(self) -> i64 { let n = (self.end - self.start).max(1) as u64; self.start + (next() % n) as i64 }
    }
    pub trait Rng { fn gen_range<T, R: SampleRange<T>>(&mut self, r: R) -> T { r.sample() } }
    pub struct ThreadRng;
    impl Rng for ThreadRng {}
    pub fn thread_rng() -> ThreadRng { ThreadRng }
}
