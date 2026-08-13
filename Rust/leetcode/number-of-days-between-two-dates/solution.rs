impl Solution {
    pub fn days_between_dates(date1: String, date2: String) -> i32 {
        let a = Self::days_from_civil(&date1);
        let b = Self::days_from_civil(&date2);
        (a - b).abs() as i32
    }

    fn days_from_civil(s: &str) -> i64 {
        let parts: Vec<&str> = s.split('-').collect();
        let mut v = [0i64; 3];
        for i in 0..3 {
            if i < parts.len() {
                v[i] = parts[i].parse::<i64>().unwrap_or(0);
            }
        }
        let (mut y, m, d) = (v[0], v[1], v[2]);
        if m <= 2 {
            y -= 1;
        }
        let era = if y >= 0 { y / 400 } else { (y - 399) / 400 };
        let yoe = y - era * 400;
        let mm = if m > 2 { m - 3 } else { m + 9 };
        let doy = (153 * mm + 2) / 5 + d - 1;
        let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
        era * 146097 + doe - 719468
    }
}
