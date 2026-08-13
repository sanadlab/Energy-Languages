use std::collections::HashSet;

impl Solution {
    pub fn min_area_rect(points: Vec<Vec<i32>>) -> i32 {
        let mut seen: HashSet<i64> = HashSet::new();
        let n = points.len();
        for p in &points {
            seen.insert(p[0] as i64 * 50000 + p[1] as i64);
        }
        let mut best: i64 = i64::MAX;
        for i in 0..n {
            for j in (i + 1)..n {
                let (x1, y1) = (points[i][0], points[i][1]);
                let (x2, y2) = (points[j][0], points[j][1]);
                if x1 != x2 && y1 != y2 {
                    if seen.contains(&(x1 as i64 * 50000 + y2 as i64))
                        && seen.contains(&(x2 as i64 * 50000 + y1 as i64)) {
                        let area = (x1 - x2).abs() as i64 * (y1 - y2).abs() as i64;
                        if area < best {
                            best = area;
                        }
                    }
                }
            }
        }
        if best == i64::MAX { 0 } else { best as i32 }
    }
}
