use std::collections::HashMap;

impl Solution {
    pub fn max_points(points: Vec<Vec<i32>>) -> i32 {
        fn gcd(a: i32, b: i32) -> i32 {
            if b == 0 { a } else { gcd(b, a % b) }
        }
        let n = points.len();
        if n <= 2 {
            return n as i32;
        }
        let mut best = 1;
        for i in 0..n {
            let mut slopes: HashMap<(i32, i32), i32> = HashMap::new();
            for j in i + 1..n {
                let mut dx = points[j][0] - points[i][0];
                let mut dy = points[j][1] - points[i][1];
                let g = gcd(dx.abs(), dy.abs());
                dx /= g;
                dy /= g;
                if dx < 0 || (dx == 0 && dy < 0) {
                    dx = -dx;
                    dy = -dy;
                }
                let c = slopes.entry((dx, dy)).or_insert(0);
                *c += 1;
                if *c + 1 > best {
                    best = *c + 1;
                }
            }
        }
        best
    }
}
