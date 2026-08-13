pub struct Solution;

impl Solution {
    pub fn abbreviate_product(left: i32, right: i32) -> String {
        let sufmod: i64 = 10000000000000; // 1e13
        let mut suf: i64 = 1;
        let mut pre: f64 = 1.0;
        let mut c2: i64 = 0;
        let mut c5: i64 = 0;
        let mut extra: i64 = 0;
        let mut i = left;
        while i <= right {
            let mut x = i as i64;
            while x % 2 == 0 { x /= 2; c2 += 1; }
            while x % 5 == 0 { x /= 5; c5 += 1; }
            suf = (suf * x) % sufmod;
            pre *= i as f64;
            while pre >= 1e15 { pre /= 10.0; extra += 1; }
            i += 1;
        }
        let c = if c2 < c5 { c2 } else { c5 };
        let r2 = c2 - c;
        let r5 = c5 - c;
        let mut k = 0;
        while k < r2 { suf = (suf * 2) % sufmod; k += 1; }
        k = 0;
        while k < r5 { suf = (suf * 5) % sufmod; k += 1; }
        let mut tmp = pre;
        let mut intdigits: i64 = 1;
        while tmp >= 10.0 { tmp /= 10.0; intdigits += 1; }
        let nfull = extra + intdigits;
        let d = nfull - c;
        if d <= 10 {
            return format!("{}e{}", suf, c);
        }
        let mut lead = pre;
        while lead >= 100000.0 { lead /= 10.0; }
        while lead < 10000.0 { lead *= 10.0; }
        let first5 = lead as i64;
        let last5 = suf % 100000;
        format!("{}...{:05}e{}", first5, last5, c)
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::abbreviate_product(20, 20);
}
