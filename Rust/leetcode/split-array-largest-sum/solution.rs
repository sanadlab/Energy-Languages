impl Solution {
    pub fn split_array(nums: Vec<i32>, k: i32) -> i32 {
        let mut lo: i64 = 0;
        let mut hi: i64 = 0;
        for &x in &nums {
            if x as i64 > lo { lo = x as i64; }
            hi += x as i64;
        }
        while lo < hi {
            let mid = lo + (hi - lo) / 2;
            let mut cnt: i64 = 1;
            let mut cur: i64 = 0;
            for &x in &nums {
                if cur + x as i64 > mid {
                    cnt += 1;
                    cur = x as i64;
                } else {
                    cur += x as i64;
                }
            }
            if cnt <= k as i64 {
                hi = mid;
            } else {
                lo = mid + 1;
            }
        }
        lo as i32
    }
}
