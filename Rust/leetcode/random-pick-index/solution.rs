struct Solution {
    nums: Vec<i32>,
}

impl Solution {
    fn new(nums: Vec<i32>) -> Self {
        Solution { nums }
    }

    fn pick(&self, target: i32) -> i32 {
        // Reservoir sampling over indices whose value == target.
        // Uses a self-contained xorshift PRNG so the cell builds with a
        // plain `rustc` (no external `rand` crate available here).
        let mut seed: u64 = 0x2545F4914F6CDD1D;
        let mut count: i32 = 0;
        let mut res: i32 = -1;
        for (i, &x) in self.nums.iter().enumerate() {
            if x == target {
                count += 1;
                seed ^= seed << 13;
                seed ^= seed >> 7;
                seed ^= seed << 17;
                if (seed % (count as u64)) == 0 {
                    res = i as i32;
                }
            }
        }
        res
    }
}
