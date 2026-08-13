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
