// Reference Rust solution for random-pick-index.
use std::cell::Cell;
use std::collections::HashMap;

struct Solution {
    indices: HashMap<i32, Vec<i32>>,
    state: Cell<u64>, // xorshift state: pick only needs a valid index
}

impl Solution {
    fn new(nums: Vec<i32>) -> Self {
        let mut indices: HashMap<i32, Vec<i32>> = HashMap::new();
        for (i, &v) in nums.iter().enumerate() {
            indices.entry(v).or_default().push(i as i32);
        }
        Self { indices, state: Cell::new(0x9E37_79B9_7F4A_7C15) }
    }

    fn pick(&self, target: i32) -> i32 {
        let v = &self.indices[&target];
        let mut x = self.state.get();
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.state.set(x);
        v[(x % v.len() as u64) as usize]
    }
}
