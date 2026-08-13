impl Solution {
    pub fn min_steps(n: i32) -> i32 {
        let mut n = n;
        let mut res = 0;
        let mut d = 2;
        while d <= n {
            while n % d == 0 {
                res += d;
                n /= d;
            }
            d += 1;
        }
        res
    }
}
