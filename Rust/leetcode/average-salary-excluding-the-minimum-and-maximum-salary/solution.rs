impl Solution {
    pub fn average(salary: Vec<i32>) -> f64 {
        let mn = *salary.iter().min().unwrap();
        let mx = *salary.iter().max().unwrap();
        let sum: i32 = salary.iter().sum();
        (sum - mn - mx) as f64 / (salary.len() - 2) as f64
    }
}
