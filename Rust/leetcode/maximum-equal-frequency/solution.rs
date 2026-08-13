impl Solution {
    pub fn max_equal_freq(nums: Vec<i32>) -> i32 {
        let n = nums.len();
        let mut count = vec![0i32; 100001];
        let mut freq = vec![0i32; n + 1];
        let mut max_f: i32 = 0;
        let mut res: i32 = 0;
        for i in 0..n {
            let v = nums[i] as usize;
            if count[v] > 0 {
                freq[count[v] as usize] -= 1;
            }
            count[v] += 1;
            freq[count[v] as usize] += 1;
            if count[v] > max_f {
                max_f = count[v];
            }
            let mf = max_f as usize;
            let ii = i as i32;
            if max_f == 1
                || freq[mf] * max_f == ii
                || (freq[mf] == 1 && (max_f - 1) * (freq[mf - 1] + 1) == ii)
            {
                res = (i + 1) as i32;
            }
        }
        res
    }
}
