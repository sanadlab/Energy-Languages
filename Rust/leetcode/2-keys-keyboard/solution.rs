impl Solution {
    pub fn min_steps(n: i32) -> i32 {
        if n == 1 { return 0; }
        let mut ans = 0; let mut d = 2; let mut m = n;
        while m > 1 {
            while m % d == 0 { ans += d; m /= d; }
            d += 1;
        }
        ans
    }
}
