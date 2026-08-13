impl Solution {
    pub fn maximum_beauty(flowers: Vec<i32>, new_flowers: i64, target: i32, full: i32, partial: i32) -> i64 {
        let n = flowers.len();
        if n == 0 { return 0; }
        let mut fl: Vec<i32> = flowers.iter().map(|&f| f.min(target)).collect();
        fl.sort();
        let mut pre = vec![0i64; n + 1];
        for i in 0..n {
            pre[i + 1] = pre[i] + fl[i] as i64;
        }
        if fl[0] == target {
            return full as i64 * n as i64;
        }
        let mut ans: i64 = 0;
        let mut i = n as i64;
        while i >= 0 {
            let iu = i as usize;
            let cost_complete = target as i64 * (n as i64 - i) - (pre[n] - pre[iu]);
            if cost_complete > new_flowers {
                i -= 1;
                continue;
            }
            let rem = new_flowers - cost_complete;
            if i == 0 {
                ans = ans.max(full as i64 * (n as i64 - i));
                i -= 1;
                continue;
            }
            let (mut lo, mut hi) = (0i32, target - 1);
            let mut best_min = 0i32;
            while lo <= hi {
                let v = lo + (hi - lo) / 2;
                let k = fl[..iu].partition_point(|&x| x < v);
                let cost = v as i64 * k as i64 - pre[k];
                if cost <= rem {
                    best_min = v;
                    lo = v + 1;
                } else {
                    hi = v - 1;
                }
            }
            ans = ans.max(full as i64 * (n as i64 - i) + best_min as i64 * partial as i64);
            i -= 1;
        }
        ans
    }
}
